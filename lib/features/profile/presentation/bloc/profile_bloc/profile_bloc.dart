import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/profile/domain/firestore_user_response.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchFirestoreUserProfile) {
      yield ProfileLoading();
      final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;
      try {
        DocumentSnapshot response = await Firestore.instance
            .collection("users")
            .document(loggedInUserKey.toString())
            .get();
        FirestoreUserResponse userResponse =
            FirestoreUserResponse.fromMap(response.data);
        yield ProfileCompleted(firestoreUserResponse: userResponse);
      } catch (e) {
        yield ProfileError(errorMessage: e);
      }
    }
  }

  @override
  ProfileState get initialState => ProfileInitial();
}
