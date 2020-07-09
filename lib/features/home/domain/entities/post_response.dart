import 'package:cloud_firestore/cloud_firestore.dart';

class PostResponse {
  final Timestamp date;
  final String image;
  final String post;
  final String postId;
  final DocumentReference userDoc;
  final String userId;

  PostResponse(
      {this.date,
      this.image,
      this.post,
      this.postId,
      this.userDoc,
      this.userId});
  PostResponse.fromMap(Map data)
      : date = data["date"],
        image = data["image"],
        post = data["post"],
        postId = data["postId"],
        userDoc = data["userDoc"],
        userId = data["userId"];
}

class CommentResponse {
  final String comment;
  final Timestamp date;
  final DocumentReference user;
  final String userId;

  CommentResponse({this.comment, this.date, this.user, this.userId});

  CommentResponse.fromMap(Map data)
      : comment = data["comment"],
        date = data["date"],
        user = data["user"],
        userId = data["userId"];
}

class ReactionResponse {
  final bool like;
  ReactionResponse({this.like});
  ReactionResponse.fromMap(Map data) : like = data["like"];
}

class PostReferenceResponse {
  final DocumentReference postDoc;

  PostReferenceResponse({this.postDoc});
  PostReferenceResponse.fromMap(Map data) : postDoc = data["postDoc"];
}
