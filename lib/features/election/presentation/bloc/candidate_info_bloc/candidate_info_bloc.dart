import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

part 'candidate_info_event.dart';
part 'candidate_info_state.dart';

class CandidateInfoBloc extends Bloc<CandidateInfoEvent, CandidateInfoState> {
  @override
  Stream<CandidateInfoState> mapEventToState(
    CandidateInfoEvent event,
  ) async* {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);
    if (event is FetchCandidate) {
      yield CandidateInfoLoading();
      final getCandidate = contract.function('getCandidate');
      CandidateResponse candidateResponse = CandidateResponse.fromMap(
          await AppConfig().ethClient().call(
              contract: contract,
              function: getCandidate,
              params: [event.candidateId]));

      yield CandidateInfoCompleted(candidate: candidateResponse);
    }
  }

  @override
  CandidateInfoState get initialState => CandidateInfoInitial();
}
