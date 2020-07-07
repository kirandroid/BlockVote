import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/widgets/toast.dart';
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
    if (event is FetchAnElection) {
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
          // sl<ElectionBloc>().add(FetchAnElection(electionId: event.electionId));
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

  @override
  ElectionDetailState get initialState => ElectionDetailInitial();
}
