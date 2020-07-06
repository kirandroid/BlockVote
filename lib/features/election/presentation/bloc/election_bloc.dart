import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/authentication/domain/entities/user_response.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
part 'election_event.dart';
part 'election_state.dart';

class ElectionBloc extends Bloc<ElectionEvent, ElectionState> {
  @override
  ElectionState get initialState => ElectionInitial();

  @override
  Stream<ElectionState> mapEventToState(
    ElectionEvent event,
  ) async* {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);
    if (event is GetAllElection) {
      List<ElectionResponse> electionList = [];
      yield ElectionLoading();

      final getElectionCount = contract.function('nextElectionId');
      final getElection = contract.function('getAnElection');
      final getUserFunction = contract.function('getUser');

      await AppConfig().ethClient().call(
          contract: contract,
          function: getElectionCount,
          params: []).then((count) async {
        for (var i = 1; i < int.parse(count.first.toString()); i++) {
          ElectionResponse electionResponse = ElectionResponse.fromMap(
              await AppConfig().ethClient().call(
                  contract: contract,
                  function: getElection,
                  params: [BigInt.from(i)]));
          UserResponse userResponse = UserResponse.fromMap(await AppConfig()
              .ethClient()
              .call(
                  contract: contract,
                  function: getUserFunction,
                  params: [electionResponse.creatorId]));
          DateTime now = DateTime.now();
          DateTime today =
              DateTime(now.year, now.month, now.day, now.hour, now.minute);
          DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(electionResponse.startDate.toString()));
          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(electionResponse.endDate.toString()));

          DateTime parsedStartDate = DateTime(startDate.year, startDate.month,
              startDate.day, startDate.hour, startDate.minute);
          DateTime parsedEndDate = DateTime(endDate.year, endDate.month,
              endDate.day, endDate.hour, endDate.minute);
          electionResponse.creatorName =
              "${userResponse.firstName} ${userResponse.lastName}";
          electionResponse.formattedStartDate =
              DateFormat("MMM dd").format(startDate);
          electionResponse.formattedEndDate =
              DateFormat("MMM dd").format(endDate);

          if (electionResponse.isActive && parsedStartDate.isBefore(today)) {
            electionResponse.status = ElectionStatus(
                status: "ACTIVE",
                statusColor: UIColors.primaryDarkTeal,
                reason: "Voter can Join.",
                shouldWarn: false);
          } else if (!electionResponse.isActive ||
              parsedEndDate.isAfter(today)) {
            electionResponse.status = ElectionStatus(
                status: "INACTIVE",
                statusColor: UIColors.primaryRed,
                reason:
                    "This election is expired or close. You cannot join but view the result.",
                shouldWarn: true);
          } else if (electionResponse.isActive &&
              parsedEndDate.isBefore(today) &&
              parsedStartDate.isAfter(today)) {
            electionResponse.status = ElectionStatus(
                status: "VOTING",
                statusColor: UIColors.primaryGreen,
                reason:
                    "This election is running. You can view the ongoing result but cannot join.",
                shouldWarn: true);
          }
          electionList.add(electionResponse);
        }
      });

      if (electionList.isNotEmpty) {
        yield ElectionCompleted(allElection: electionList);
      } else {
        yield ElectionError(errorMessage: "No Elections Found!");
      }
    } else if (event is CreateElection) {
      yield CreateElectionLoading();
      String imageName = '';
      List<EthereumAddress> voter = [];
      if (event.image != null) {
        var uuid = new Uuid();
        imageName = uuid.v4();
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child("ElectionCover/$imageName");

        final StorageUploadTask uploadTask =
            storageReference.putFile(event.image);
        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());
        print(url);
      } else {
        imageName = 'blockvote.png';
      }

      for (var i = 0; i < event.candidates.length; i++) {
        CandidateResponse candidate = event.candidates[i];
        await AppConfig.runTransaction(
            functionName: 'addCandidate',
            parameter: [
              candidate.candidateId,
              candidate.candidateName,
              candidate.candidateImage
            ]).then((value) => print("Candidate : $value"));
      }

      final EthereumAddress userPublicKey = await AppConfig.loggedInUserKey;

      final bool response = await AppConfig.runTransaction(
          functionName: 'createElection',
          parameter: [
            event.electionName,
            userPublicKey,
            AppConfig().hashPassword(password: event.electionPassword),
            event.hasPassword,
            BigInt.from(event.startDate.millisecondsSinceEpoch),
            BigInt.from(event.endDate.millisecondsSinceEpoch),
            event.isActive,
            event.candidates.map((candidate) => candidate.candidateId).toList(),
            imageName,
            voter
          ]);

      if (response) {
        yield CreateElectionCompleted();
      } else {
        yield CreateElectionError(
            errorMessage: "Some error occurred while creating election!");
      }
    } else if (event is FetchAnElection) {
      yield FetchElectionLoading();
      List<CandidateResponse> candidatesList = [];

      final getAnElection = contract.function('getAnElection');
      final getCandidate = contract.function('getCandidate');
      try {
        ElectionResponse electionResponse = ElectionResponse.fromMap(
            await AppConfig().ethClient().call(
                contract: contract,
                function: getAnElection,
                params: [event.electionId]));
        for (var i = 0; i < electionResponse.candidates.length; i++) {
          String candidateId = electionResponse.candidates[i];
          CandidateResponse candidateResponse = CandidateResponse.fromMap(
              await AppConfig().ethClient().call(
                  contract: contract,
                  function: getCandidate,
                  params: [candidateId]));
          candidatesList.add(candidateResponse);
        }

        yield FetchAnElectionCompleted(
            candidates: candidatesList, election: electionResponse);
      } catch (e) {
        yield FetchElectionError(errorMessage: "Election may be deleted.");
      }
    } else if (event is JoinAnElection) {
      if (event.voterList.contains(event.loggedInUser)) {
        Toast().showToast(
            bgColor: UIColors.primaryPink,
            context: event.context,
            title: "Error",
            message: "You have already joined the election");
      } else {
        final bool response = await AppConfig.runTransaction(
            functionName: 'joinElection',
            parameter: [event.electionId, event.loggedInUser]);
        if (response) {
          Toast().showToast(
              bgColor: UIColors.primaryDarkTeal,
              context: event.context,
              title: "Success",
              message: "Election Joined Successfully!");
          sl<ElectionBloc>().add(FetchAnElection(electionId: event.electionId));
        } else {
          Toast().showToast(
              bgColor: UIColors.primaryPink,
              context: event.context,
              title: "Failed to join",
              message: "Error failed to join election.");
        }
      }
    }
  }
}
