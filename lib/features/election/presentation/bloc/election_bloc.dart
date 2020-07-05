import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto/crypto.dart';
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
    } else if (event is CreateElection) {
      yield ElectionLoading();
      String imageName = '';
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
            event.candidates,
            imageName
          ]);

      if (response) {
        yield CreateElectionCompleted();
      } else {
        yield ElectionError(
            errorMessage: "Some error occurred while creating election!");
      }
    }
  }
}
