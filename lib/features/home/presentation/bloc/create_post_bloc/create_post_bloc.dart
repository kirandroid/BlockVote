import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  @override
  Stream<CreatePostState> mapEventToState(
    CreatePostEvent event,
  ) async* {
    if (event is CreatePost) {
      final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;

      yield CreatePostLoading();
      try {
        if (event.postText.isEmpty) {
          yield CreatePostInitial();
          Toast().showToast(
              context: event.context,
              message: "Please type some Post.",
              title: "Blank Post");
        } else {
          final Firestore _db = Firestore.instance;
          var postRef = _db.collection("posts").document();
          var postId = postRef.documentID;
          DocumentReference userReference = Firestore.instance
              .document("users/" + loggedInUserKey.toString());
          DocumentReference postReference =
              Firestore.instance.document("posts/" + postId);
          var uuid = new Uuid();
          String postImageUrl = "";

          if (event.postImage != null) {
            StorageReference storageReference =
                FirebaseStorage.instance.ref().child("postImages/${uuid.v4()}");
            final StorageUploadTask uploadTask =
                storageReference.putFile(event.postImage);
            final StorageTaskSnapshot downloadUrl =
                (await uploadTask.onComplete);
            postImageUrl = (await downloadUrl.ref.getDownloadURL());
          }
          await postRef.setData({
            "image": postImageUrl,
            "date": DateTime.now(),
            "userId": loggedInUserKey.toString(),
            "userDoc": userReference,
            "post": event.postText,
            "postId": postId
          });
          await _db
              .collection("users")
              .document(loggedInUserKey.toString())
              .collection("posts")
              .document()
              .setData({"postDoc": postReference});
          yield CreatePostCompleted();
        }
      } catch (e) {
        yield CreatePostError();
      }
    }
  }

  @override
  CreatePostState get initialState => CreatePostInitial();
}
