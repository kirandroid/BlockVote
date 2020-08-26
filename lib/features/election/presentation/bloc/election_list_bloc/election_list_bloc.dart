import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/voting_config.dart';
import 'package:evoting/features/authentication/domain/entities/user_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:evoting/features/profile/domain/firestore_user_response.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
part 'election_list_event.dart';
part 'election_list_state.dart';

class ElectionListBloc extends Bloc<ElectionListEvent, ElectionListState> {
  @override
  Stream<ElectionListState> mapEventToState(
    ElectionListEvent event,
  ) async* {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);

    if (event is GetAllElection) {
      List<ElectionResponse> electionList = [];
      yield ElectionListLoading();

      final getElectionIdList = contract.function('getAllElectionId');
      final getElection = contract.function('getAnElection');
      await AppConfig().ethClient().call(
          contract: contract,
          function: getElectionIdList,
          params: []).then((electionIdList) async {
        for (var i = 0; i < electionIdList.first.length; i++) {
          ElectionResponse electionResponse = ElectionResponse.fromMap(
              await AppConfig().ethClient().call(
                  contract: contract,
                  function: getElection,
                  params: [electionIdList.first[i]]));
          DocumentSnapshot response = await Firestore.instance
              .collection("users")
              .document(electionResponse.creatorId.toString())
              .get();
          FirestoreUserResponse userResponse =
              FirestoreUserResponse.fromMap(response.data);

          DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(electionResponse.startDate.toString()));
          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(electionResponse.endDate.toString()));

          electionResponse.creatorName =
              "${userResponse.firstName} ${userResponse.lastName}";
          electionResponse.formattedStartDate =
              DateFormat("MMM dd").format(startDate);
          electionResponse.formattedEndDate =
              DateFormat("MMM dd").format(endDate);
          electionResponse.status = VotingConfig()
              .checkVotingStatus(electionResponse: electionResponse);

          electionList.add(electionResponse);
        }
      });

      if (electionList.isNotEmpty) {
        yield ElectionListCompleted(
            allElection: electionList.reversed.toList());
      } else {
        yield ElectionError(errorMessage: "No Elections Found!");
      }
    }
  }

  @override
  ElectionListState get initialState => ElectionListInitial();
}
