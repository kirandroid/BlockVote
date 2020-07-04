import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:web3dart/web3dart.dart';

part 'election_event.dart';
part 'election_state.dart';

class ElectionBloc extends Bloc<ElectionEvent, ElectionState> {
  @override
  ElectionState get initialState => ElectionInitial();

  @override
  Stream<ElectionState> mapEventToState(
    ElectionEvent event,
  ) async* {
    if (event is GetAllElection) {
      List<ElectionResponse> electionList = [];
      yield ElectionLoading();

      final DeployedContract contract =
          await AppConfig.contract.then((value) => value);

      final getElectionCount = contract.function('nextElectionId');
      final getElection = contract.function('getAnElection');

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
          electionList.add(electionResponse);
        }
      });
      if (electionList.isNotEmpty) {
        yield ElectionCompleted(allElection: electionList);
      } else {
        yield ElectionError(errorMessage: "No Elections Found!");
      }
    }
  }
}
