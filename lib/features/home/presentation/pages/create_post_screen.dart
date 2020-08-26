import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/post_image_picker.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/home/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:evoting/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  ProfileBloc _profileBloc = sl<ProfileBloc>();
  CreatePostBloc _createPostBloc = sl<CreatePostBloc>();
  String loggedInUser;
  File postImage;
  bool isUploading = false;
  final FocusNode postFieldFocus = FocusNode();
  TextEditingController postTextFieldController = TextEditingController();
  bool isLoading = false;

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
    _profileBloc
        .add(FetchFirestoreUserProfile(context: context, userId: loggedInUser));
  }

  @override
  void dispose() {
    _profileBloc.close();
    _createPostBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _createPostBloc,
      listener: (BuildContext context, CreatePostState state) {
        if (state is CreatePostLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreatePostCompleted) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (BuildContext context, CreatePostState state) {
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
              ),
            ),
            centerTitle: true,
            title: Text(
              "Create Post",
              style: StyleText.ralewayMedium.copyWith(
                  fontSize: UISize.fontSize(14), color: UIColors.darkGray),
            ),
            actions: <Widget>[
              InkWell(
                onTap: state is CreatePostLoading
                    ? null
                    : () {
                        _createPostBloc.add(CreatePost(
                            context: context,
                            postImage: postImage,
                            postText: postTextFieldController.text));
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Post",
                          style: StyleText.ralewayMedium.copyWith(
                              fontSize: UISize.fontSize(14),
                              color: UIColors.primaryDarkTeal),
                        ),
                ),
              )
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<ProfileBloc, ProfileState>(
                        bloc: this._profileBloc,
                        builder: (BuildContext context, ProfileState state) {
                          if (state is ProfileLoading) {
                            return ShimmerEffect();
                          } else if (state is ProfileCompleted) {
                            return Row(
                              children: <Widget>[
                                CachedNetworkImage(
                                  height: UISize.width(50),
                                  width: UISize.width(50),
                                  imageUrl: state
                                      .firestoreUserResponse.profilePicture,
                                  fit: BoxFit.cover,
                                  // alignment: Alignment.topCenter,
                                  placeholder: (context, url) => ShimmerEffect(
                                    height: UISize.width(50),
                                    width: UISize.width(50),
                                    isCircular: true,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      ShimmerEffect(
                                    height: UISize.width(50),
                                    width: UISize.width(50),
                                    isCircular: true,
                                  ),

                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: UISize.width(50),
                                    width: UISize.width(50),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${state.firestoreUserResponse.firstName} ${state.firestoreUserResponse.lastName}",
                                  style: StyleText.ralewayMedium.copyWith(
                                      color: UIColors.darkGray,
                                      fontSize: UISize.fontSize(12)),
                                )
                              ],
                            );
                          }
                          return Container();
                        }),
                    TextField(
                      focusNode: postFieldFocus,
                      controller: postTextFieldController,
                      autocorrect: false,
                      autofocus: false,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      style: StyleText.ralewayMedium.copyWith(
                          fontSize: UISize.fontSize(14),
                          color: UIColors.darkGray),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: UIColors.lightGray,
                        contentPadding: EdgeInsets.only(
                            top: UISize.width(14),
                            bottom: UISize.width(14),
                            left: UISize.width(15)),
                        hintText: "Write something...",
                        hintStyle: StyleText.ralewayMedium.copyWith(
                            fontSize: UISize.fontSize(13),
                            color: UIColors.greyText),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(UISize.width(23)),
                            borderSide: BorderSide(style: BorderStyle.none)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(UISize.width(23)),
                            borderSide: BorderSide(style: BorderStyle.none)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: UISize.width(20)),
                      child: PostImagePicker(
                        listener: (File file) {
                          this.postImage = file;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
