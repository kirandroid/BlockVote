import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/voting_config.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

part 'election_detail_event.dart';
part 'election_detail_state.dart';

class ElectionDetailBloc
    extends Bloc<ElectionDetailEvent, ElectionDetailState> {
  @override
  Stream<ElectionDetailState> mapEventToState(
    ElectionDetailEvent event,
  ) async* {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);
    final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;
    if (event is FetchAnElection) {
      yield FetchElectionLoading();
      List<CandidateResponse> candidatesList = [];
      List<dynamic> allVotedVoterList = [];

      final getAnElection = contract.function('getAnElection');
      final getCandidate = contract.function('getCandidate');
      final getAllVotedVoter = contract.function('getAllElectionVoter');
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

        await AppConfig().ethClient().call(
            contract: contract,
            function: getAllVotedVoter,
            params: [
              event.electionId
            ]).then((value) => allVotedVoterList = value.first);

        electionResponse.votedVoter = allVotedVoterList;
        electionResponse.status = VotingConfig()
            .checkVotingStatus(electionResponse: electionResponse);
        ElectionStatus electionStatus = VotingConfig()
            .checkVotingStatus(electionResponse: electionResponse);
        Color joinButtonColor = electionStatus.status == 'ACTIVE' &&
                (electionResponse.pendingVoter.contains(loggedInUserKey) ||
                    electionResponse.approvedVoter.contains(loggedInUserKey))
            ? UIColors.primaryYellow
            : electionStatus.status == 'INACTIVE'
                ? UIColors.primaryRed
                : electionStatus.status == 'VOTING'
                    ? UIColors.primaryYellow
                    : electionResponse.pendingVoter.contains(loggedInUserKey)
                        ? UIColors.primaryRed
                        : UIColors.primaryGreen;

        String joinButtonText = electionStatus.status == 'ACTIVE' &&
                (electionResponse.pendingVoter.contains(loggedInUserKey) ||
                    electionResponse.approvedVoter.contains(loggedInUserKey))
            ? "JOINED"
            : electionStatus.status == 'INACTIVE'
                ? "CLOSED"
                : electionStatus.status == "VOTING"
                    ? electionStatus.status
                    : electionResponse.pendingVoter.contains(loggedInUserKey)
                        ? "JOINED"
                        : "JOIN";

        yield FetchAnElectionCompleted(
            candidates: candidatesList,
            election: electionResponse,
            joinButtonColor: joinButtonColor,
            joinButtonText: joinButtonText);
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
          await Firestore.instance
              .collection("users")
              .document(event.loggedInUser.toString())
              .updateData({
            "participatedElections": FieldValue.arrayUnion([event.electionId])
          });
          Toast().showToast(
              bgColor: UIColors.primaryDarkTeal,
              context: event.context,
              title: "Success",
              message: "Election Joined Successfully!");
          sl<ElectionDetailBloc>()
              .add(FetchAnElection(electionId: event.electionId));
        } else {
          Toast().showToast(
              bgColor: UIColors.primaryPink,
              context: event.context,
              title: "Failed to join",
              message: "Error failed to join election.");
        }
      }
    } else if (event is VoteCandidate) {
      if (event.candidateId == '') {
        Toast().showToast(
            context: event.context,
            message: "Please choose a candidate!",
            title: "Error");
      } else {
        final bool response = await AppConfig.runTransaction(
            functionName: 'voteCandidate',
            parameter: [event.candidateId, event.voterId, event.electionId]);
        if (response) {
          print("Success");
          sl<ElectionDetailBloc>()
              .add(FetchAnElection(electionId: event.electionId));
        } else {
          print("Error");
        }
      }
    } else if (event is ApproveVoter) {
      final bool response = await AppConfig.runTransaction(
          functionName: 'approveVoter',
          parameter: [event.voterId, event.electionId]);
      if (response) {
        print("Success");
        sl<ElectionDetailBloc>()
            .add(FetchAnElection(electionId: event.electionId));
      } else {
        print("Error");
      }
    }
  }

  @override
  ElectionDetailState get initialState => ElectionDetailInitial();
}
