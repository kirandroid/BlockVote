import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';

part 'create_election_event.dart';
part 'create_election_state.dart';

class CreateElectionBloc
    extends Bloc<CreateElectionEvent, CreateElectionState> {
  @override
  Stream<CreateElectionState> mapEventToState(
    CreateElectionEvent event,
  ) async* {
    if (event is CreateElection) {
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
    }
  }

  @override
  CreateElectionState get initialState => CreateElectionInitial();
}
