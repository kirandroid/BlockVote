import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:web3dart/web3dart.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final String loggedInUser;
  PostDetailScreen({@required this.postId, @required this.loggedInUser});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  ProfileBloc _profileBloc = sl<ProfileBloc>();
  String loggedInUser;
  final FocusNode commentFieldFocus = FocusNode();
  TextEditingController commentTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  void getLoggedInUser() async {
    final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;
    setState(() {
      loggedInUser = loggedInUserKey.toString();
    });
    _profileBloc.add(FetchFirestoreUserProfile());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  Future<dynamic> referenceData(DocumentReference documentReference) async {
    DocumentSnapshot reference = await documentReference.get();
    return reference.data;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: StreamBuilder(
          stream: Firestore.instance
              .collection("posts")
              .document(widget.postId)
              .snapshots(),
          builder: (context, postSnapshot) {
            if (!postSnapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              Timestamp postDate = postSnapshot.data["date"];

              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.white70,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      leading: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: UIColors.darkGray,
                          )),
                      title: FutureBuilder(
                          future: referenceData(postSnapshot.data['userDoc']),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> posterData) {
                            if (posterData.connectionState ==
                                ConnectionState.waiting) {
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
                              return InkWell(
                                onTap: () {
                                  // posterData.data["userType"] == "guide"
                                  //     ? Router.navigator.pushNamed(
                                  //         Router.guideProfileScreen,
                                  //         arguments:
                                  //             GuideProfileScreenArguments(
                                  //                 userId: posterData.data["id"],
                                  //                 isFromTab: false,
                                  //                 status: posterData
                                  //                     .data["status"]))
                                  //     : Router.navigator.pushNamed(
                                  //         Router.touristProfileScreen,
                                  //         arguments:
                                  //             TouristProfileScreenArguments(
                                  //                 isFromTab: false,
                                  //                 userId:
                                  //                     posterData.data["id"]));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      height: UISize.width(40),
                                      width: UISize.width(40),
                                      imageUrl:
                                          posterData.data["profilePicture"],
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
                                          style: StyleText.ralewayMedium
                                              .copyWith(
                                                  fontSize: UISize.fontSize(12),
                                                  color: UIColors.darkGray),
                                        ),
                                        Text(
                                          timeago.format(postDate.toDate()),
                                          style: StyleText.ralewayMedium
                                              .copyWith(
                                                  color: UIColors.darkGray,
                                                  fontSize: UISize.fontSize(9)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          })),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(UISize.width(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(postSnapshot.data["post"],
                                        style: StyleText.ralewayMedium.copyWith(
                                            fontSize: UISize.fontSize(12),
                                            color: UIColors.darkGray)),
                                  ),
                                  postSnapshot.data["image"] != ""
                                      ? Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: CachedNetworkImage(
                                            height: UISize.width(200),
                                            imageUrl:
                                                postSnapshot.data["image"],
                                            fit: BoxFit.cover,
                                            // alignment: Alignment.topCenter,
                                            placeholder: (context, url) =>
                                                ShimmerEffect(
                                              height: UISize.width(200),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    ShimmerEffect(
                                              height: UISize.width(200),
                                            ),

                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: UISize.width(200),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("posts")
                                              .document(
                                                  postSnapshot.data["postId"])
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
                                              style: StyleText.ralewayMedium
                                                  .copyWith(
                                                      color: UIColors.darkGray,
                                                      fontSize:
                                                          UISize.fontSize(9)),
                                            );
                                          }),
                                      StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("posts")
                                              .document(
                                                  postSnapshot.data["postId"])
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
                                              style: StyleText.ralewayRegular
                                                  .copyWith(
                                                      color: UIColors.darkGray,
                                                      fontSize:
                                                          UISize.fontSize(9)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("posts")
                                              .document(
                                                  postSnapshot.data["postId"])
                                              .collection("reaction")
                                              .document(widget.loggedInUser)
                                              .snapshots(),
                                          builder: (context, reactionSnapshot) {
                                            if (!reactionSnapshot.hasData) {
                                              return InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                              .ralewayRegular
                                                              .copyWith(
                                                                  fontSize: UISize
                                                                      .fontSize(
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
                                                    .document(postSnapshot
                                                        .data["postId"])
                                                    .collection("reaction")
                                                    .document(
                                                        widget.loggedInUser)
                                                    .setData({
                                                  "like": reactionSnapshot
                                                              .data.data ==
                                                          null
                                                      ? true
                                                      : !reactionSnapshot
                                                          .data["like"]
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      reactionSnapshot
                                                                  .data.data ==
                                                              null
                                                          ? Icons
                                                              .favorite_border
                                                          : reactionSnapshot
                                                                  .data["like"]
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                      color: reactionSnapshot
                                                                  .data.data ==
                                                              null
                                                          ? UIColors.darkGray
                                                          : reactionSnapshot
                                                                  .data["like"]
                                                              ? UIColors
                                                                  .primaryDarkTeal
                                                              : UIColors
                                                                  .darkGray,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        reactionSnapshot
                                                                    .data.data ==
                                                                null
                                                            ? "Like"
                                                            : reactionSnapshot
                                                                        .data[
                                                                    "like"]
                                                                ? "Liked"
                                                                : "Like",
                                                        style: StyleText.ralewayRegular.copyWith(
                                                            fontSize: UISize
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
                                          commentFieldFocus.requestFocus();
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
                                                  style: StyleText
                                                      .ralewayRegular
                                                      .copyWith(
                                                          fontSize:
                                                              UISize.fontSize(
                                                                  11),
                                                          color: UIColors
                                                              .darkGray))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      height: 1,
                                      color: UIColors.lightGray,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("posts")
                                          .document(postSnapshot.data["postId"])
                                          .collection("comments")
                                          .orderBy("date", descending: true)
                                          .snapshots(),
                                      builder: (context, commentSnapshot) {
                                        if (!commentSnapshot.hasData) {
                                          return ShimmerEffect(
                                            width: 20,
                                            height: 10,
                                          );
                                        }
                                        return Column(
                                            children: commentSnapshot
                                                .data.documents
                                                .map<Widget>((comment) {
                                          Timestamp commentDate =
                                              comment["date"];
                                          return FutureBuilder(
                                              future: referenceData(
                                                  comment['user']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      commentUser) {
                                                if (commentUser
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ShimmerEffect(
                                                        height: 50,
                                                      ),
                                                    ),
                                                  );
                                                } else if (commentUser
                                                        .connectionState ==
                                                    ConnectionState.active) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (commentUser
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          CachedNetworkImage(
                                                            height:
                                                                UISize.width(
                                                                    30),
                                                            width: UISize.width(
                                                                30),
                                                            imageUrl: commentUser
                                                                    .data[
                                                                "profilePicture"],
                                                            fit: BoxFit.cover,
                                                            // alignment: Alignment.topCenter,
                                                            placeholder: (context,
                                                                    url) =>
                                                                ShimmerEffect(
                                                              height:
                                                                  UISize.width(
                                                                      30),
                                                              width:
                                                                  UISize.width(
                                                                      30),
                                                              isCircular: true,
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                ShimmerEffect(
                                                              height:
                                                                  UISize.width(
                                                                      30),
                                                              width:
                                                                  UISize.width(
                                                                      30),
                                                              isCircular: true,
                                                            ),

                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              height:
                                                                  UISize.width(
                                                                      30),
                                                              width:
                                                                  UISize.width(
                                                                      30),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      shape: BoxShape
                                                                          .circle),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "${commentUser.data["firstName"]} ${commentUser.data["lastName"]}",
                                                                        style: StyleText.ralewayMedium.copyWith(
                                                                            fontSize:
                                                                                UISize.fontSize(12),
                                                                            color: UIColors.darkGray),
                                                                      ),
                                                                      Text(
                                                                        comment[
                                                                            "comment"],
                                                                        style: StyleText.ralewayRegular.copyWith(
                                                                            color:
                                                                                UIColors.darkGray,
                                                                            fontSize: UISize.fontSize(12)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                  child: Text(
                                                                    timeago.format(
                                                                        commentDate
                                                                            .toDate()),
                                                                    style: StyleText
                                                                        .ralewayRegular
                                                                        .copyWith(
                                                                            color:
                                                                                UIColors.darkGray,
                                                                            fontSize: UISize.fontSize(9)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Text("No Data");
                                              });
                                        }).toList());
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // padding:
                          //     EdgeInsets.symmetric(horizontal: UISize.width(16)),
                          height: UISize.width(50),
                          color: UIColors.lightGray,
                          child: Row(
                            children: <Widget>[
                              BlocBuilder<ProfileBloc, ProfileState>(
                                  bloc: this._profileBloc,
                                  builder: (BuildContext context,
                                      ProfileState state) {
                                    if (state is ProfileLoading) {
                                      return ShimmerEffect();
                                    } else if (state is ProfileCompleted) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: CachedNetworkImage(
                                                height: UISize.width(30),
                                                width: UISize.width(30),
                                                imageUrl: state
                                                    .firestoreUserResponse
                                                    .profilePicture,
                                                fit: BoxFit.cover,
                                                // alignment: Alignment.topCenter,
                                                placeholder: (context, url) =>
                                                    ShimmerEffect(
                                                  height: UISize.width(30),
                                                  width: UISize.width(30),
                                                  isCircular: true,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        ShimmerEffect(
                                                  height: UISize.width(30),
                                                  width: UISize.width(30),
                                                  isCircular: true,
                                                ),

                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: UISize.width(30),
                                                  width: UISize.width(30),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IntrinsicHeight(
                                                  child: TextField(
                                                    focusNode:
                                                        commentFieldFocus,
                                                    controller:
                                                        commentTextFieldController,
                                                    autocorrect: false,
                                                    autofocus: false,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: StyleText
                                                        .ralewayMedium
                                                        .copyWith(
                                                            fontSize:
                                                                UISize.fontSize(
                                                                    13),
                                                            color: UIColors
                                                                .darkGray),
                                                    // onChanged: searchOperation,
                                                    // onTap: _handleSearchStart,
                                                    onSubmitted: (text) async {
                                                      if (text.isEmpty) {
                                                        Toast().showToast(
                                                            context: context,
                                                            message:
                                                                "Please type some comments.",
                                                            title:
                                                                "Blank Comment");
                                                      } else {
                                                        final Firestore _db =
                                                            Firestore.instance;
                                                        DocumentReference
                                                            commenterReference =
                                                            Firestore.instance
                                                                .document("users/" +
                                                                    loggedInUser);
                                                        await _db
                                                            .collection("posts")
                                                            .document(
                                                                postSnapshot
                                                                        .data[
                                                                    "postId"])
                                                            .collection(
                                                                "comments")
                                                            .document()
                                                            .setData({
                                                          "comment": text,
                                                          "date":
                                                              DateTime.now(),
                                                          "userId":
                                                              loggedInUser,
                                                          "user":
                                                              commenterReference
                                                        });
                                                        commentTextFieldController
                                                            .clear();
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          UIColors.primaryWhite,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: UISize.width(
                                                                  14),
                                                              bottom:
                                                                  UISize.width(
                                                                      14),
                                                              left:
                                                                  UISize.width(
                                                                      15)),
                                                      hintText:
                                                          "Write a comment...",
                                                      hintStyle: StyleText
                                                          .ralewayMedium
                                                          .copyWith(
                                                              fontSize: UISize
                                                                  .fontSize(12),
                                                              color: UIColors
                                                                  .greyText),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(UISize
                                                                      .width(
                                                                          23)),
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .none)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(UISize
                                                                      .width(
                                                                          23)),
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .none)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      child: Text("No Data"),
                                    );
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            }
          }),
    );
  }
}
