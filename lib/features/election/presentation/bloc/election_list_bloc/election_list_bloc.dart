import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
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
          // UserResponse userResponse = UserResponse.fromMap(await AppConfig()
          //     .ethClient()
          //     .call(
          //         contract: contract,
          //         function: getUserFunction,
          //         params: [electionResponse.creatorId]));

          DocumentSnapshot response = await Firestore.instance
              .collection("users")
              .document(electionResponse.creatorId.toString())
              .get();
          FirestoreUserResponse userResponse =
              FirestoreUserResponse.fromMap(response.data);
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
        yield ElectionListCompleted(allElection: electionList);
      } else {
        yield ElectionError(errorMessage: "No Elections Found!");
      }
    }
  }

  @override
  ElectionListState get initialState => ElectionListInitial();
}
