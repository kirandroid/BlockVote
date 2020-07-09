import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/empty_screen.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:web3dart/web3dart.dart';

class PostContainer extends StatefulWidget {
  final bool isOfProfile;
  final String profileId;
  PostContainer({@required this.isOfProfile, this.profileId});
  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  // ProfileBloc _profileBloc;
  String loggedInUser;

  @override
  void initState() {
    super.initState();
    // _profileBloc = sl<ProfileBloc>();
    getLoggedInUser();
  }

  void getLoggedInUser() async {
    final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;
    setState(() {
      loggedInUser = loggedInUserKey.toString();
    });
  }

  @override
  void dispose() {
    // _profileBloc.close();
    super.dispose();
  }

  Future<dynamic> referenceData(DocumentReference documentReference) async {
    DocumentSnapshot reference = await documentReference.get();
    return reference.data;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("posts")
            .orderBy("date", descending: true)
            .where("userId",
                isEqualTo: widget.isOfProfile ? widget.profileId : null)
            .snapshots(),
        builder: (context, postSnapshot) {
          if (!postSnapshot.hasData) {
            return Text("Loading..");
          }
          if (postSnapshot.data.documents.length <= 0) {
            return EmptyScreen(
              emptyMsg: "No Posts",
            );
          }

          return Column(
              children: postSnapshot.data.documents.map<Widget>((post) {
            Timestamp postDate = post["date"];
            return FutureBuilder(
                future: referenceData(post['userDoc']),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> posterData) {
                  if (posterData.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerEffect(
                          height: 50,
                        ),
                      ),
                    );
                  } else if (posterData.connectionState ==
                      ConnectionState.active) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (posterData.connectionState ==
                      ConnectionState.done) {
                    return Card(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(UISize.width(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: widget.isOfProfile
                                  ? null
                                  : () {
                                      ExtendedNavigator.of(context)
                                          .pushNamed(Routes.profileScreen);
                                    },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: UISize.width(40),
                                    width: UISize.width(40),
                                    imageUrl: posterData.data["profilePicture"],
                                    fit: BoxFit.cover,
                                    // alignment: Alignment.topCenter,
                                    placeholder: (context, url) =>
                                        ShimmerEffect(
                                      height: UISize.width(40),
                                      width: UISize.width(40),
                                      isCircular: true,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        ShimmerEffect(
                                      height: UISize.width(40),
                                      width: UISize.width(40),
                                      isCircular: true,
                                    ),

                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: UISize.width(40),
                                      width: UISize.width(40),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${posterData.data["firstName"]} ${posterData.data["lastName"]}",
                                        style: StyleText.ralewayMedium.copyWith(
                                            fontSize: UISize.fontSize(12),
                                            color: UIColors.darkGray),
                                      ),
                                      Text(
                                        timeago.format(postDate.toDate()),
                                        style: StyleText.ralewayMedium.copyWith(
                                            color: UIColors.darkGray,
                                            fontSize: UISize.fontSize(9)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ExtendedNavigator.of(context).pushNamed(
                                    Routes.postDetailScreen,
                                    arguments: PostDetailScreenArguments(
                                        postId: post["postId"],
                                        loggedInUser: loggedInUser));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(post["post"],
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: StyleText.ralewayMedium.copyWith(
                                            fontSize: UISize.fontSize(12),
                                            color: UIColors.darkGray)),
                                  ),
                                  post["image"] != ""
                                      ? Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: CachedNetworkImage(
                                            height: UISize.width(150),
                                            imageUrl: post["image"],
                                            fit: BoxFit.cover,
                                            // alignment: Alignment.topCenter,
                                            placeholder: (context, url) =>
                                                ShimmerEffect(
                                              height: UISize.width(150),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    ShimmerEffect(
                                              height: UISize.width(150),
                                            ),

                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: UISize.width(150),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                // shape: BoxShape.circle
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("posts")
                                        .document(post["postId"])
                                        .collection("reaction")
                                        .where('like', isEqualTo: true)
                                        .snapshots(),
                                    builder: (context, reactionSnapshot) {
                                      if (!reactionSnapshot.hasData) {
                                        return ShimmerEffect(
                                          width: 20,
                                          height: 10,
                                        );
                                      }
                                      return Text(
                                        "${reactionSnapshot.data.documents.length} likes",
                                        style: StyleText.ralewayMedium.copyWith(
                                            color: UIColors.darkGray,
                                            fontSize: UISize.fontSize(9)),
                                      );
                                    }),
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("posts")
                                        .document(post["postId"])
                                        .collection("comments")
                                        .snapshots(),
                                    builder: (context, commentSnapshot) {
                                      if (!commentSnapshot.hasData) {
                                        return ShimmerEffect(
                                          width: 20,
                                          height: 10,
                                        );
                                      }
                                      return Text(
                                        "${commentSnapshot.data.documents.length} comments",
                                        style: StyleText.ralewayMedium.copyWith(
                                            color: UIColors.darkGray,
                                            fontSize: UISize.fontSize(9)),
                                      );
                                    }),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Container(
                                height: 1,
                                color: UIColors.lightGray,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("posts")
                                        .document(post["postId"])
                                        .collection("reaction")
                                        .document(loggedInUser)
                                        .snapshots(),
                                    builder: (context, reactionSnapshot) {
                                      if (!reactionSnapshot.hasData) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.favorite_border,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Like",
                                                    style: StyleText
                                                        .ralewayMedium
                                                        .copyWith(
                                                            fontSize:
                                                                UISize.fontSize(
                                                                    11),
                                                            color: UIColors
                                                                .darkGray))
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return InkWell(
                                        onTap: () async {
                                          final Firestore _db =
                                              Firestore.instance;
                                          await _db
                                              .collection("posts")
                                              .document(post["postId"])
                                              .collection("reaction")
                                              .document(loggedInUser)
                                              .setData({
                                            "like": reactionSnapshot
                                                        .data.data ==
                                                    null
                                                ? true
                                                : !reactionSnapshot.data["like"]
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                reactionSnapshot.data.data ==
                                                        null
                                                    ? Icons.favorite_border
                                                    : reactionSnapshot
                                                            .data["like"]
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                color: reactionSnapshot
                                                            .data.data ==
                                                        null
                                                    ? UIColors.darkGray
                                                    : reactionSnapshot
                                                            .data["like"]
                                                        ? UIColors
                                                            .primaryDarkTeal
                                                        : UIColors.darkGray,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  reactionSnapshot.data.data ==
                                                          null
                                                      ? "Like"
                                                      : reactionSnapshot
                                                              .data["like"]
                                                          ? "Liked"
                                                          : "Like",
                                                  style: StyleText
                                                      .ralewayMedium
                                                      .copyWith(
                                                          fontSize:
                                                              UISize
                                                                  .fontSize(11),
                                                          color: reactionSnapshot
                                                                      .data
                                                                      .data ==
                                                                  null
                                                              ? UIColors
                                                                  .darkGray
                                                              : reactionSnapshot
                                                                          .data[
                                                                      "like"]
                                                                  ? UIColors
                                                                      .primaryDarkTeal
                                                                  : UIColors
                                                                      .darkGray))
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                InkWell(
                                  onTap: () {
                                    ExtendedNavigator.of(context).pushNamed(
                                        Routes.postDetailScreen,
                                        arguments: PostDetailScreenArguments(
                                            postId: post["postId"],
                                            loggedInUser: loggedInUser));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.message,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Comment",
                                            style: StyleText.ralewayMedium
                                                .copyWith(
                                                    fontSize:
                                                        UISize.fontSize(11),
                                                    color: UIColors.darkGray))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Text("No Posts");
                });
          }).toList());
        });
  }
}
