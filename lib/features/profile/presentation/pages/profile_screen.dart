import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/strings.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/home/presentation/widgets/postContainer.dart';
import 'package:evoting/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  ProfileScreen({@required this.userId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = sl<ProfileBloc>();
    getUserProfile();
    super.initState();
  }

  void getUserProfile() {
    _profileBloc.add(
        FetchFirestoreUserProfile(context: context, userId: widget.userId));
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: UIColors.primaryWhite,
        //   actions: <Widget>[_menu()],
        // ),
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: UISize.width(20),
            right: UISize.width(20),
            left: UISize.width(20)),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(right: 0, child: _menu()),
                  BlocBuilder<ProfileBloc, ProfileState>(
                      bloc: this._profileBloc,
                      builder: (BuildContext context, ProfileState state) {
                        if (state is ProfileLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ProfileError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else if (state is ProfileCompleted) {
                          return Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    state.firestoreUserResponse.profilePicture,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => ShimmerEffect(
                                  height: UISize.width(100),
                                  width: UISize.width(100),
                                  isCircular: true,
                                ),
                                errorWidget: (context, url, error) =>
                                    ShimmerEffect(
                                  height: UISize.width(100),
                                  width: UISize.width(100),
                                  isCircular: true,
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: UISize.width(100),
                                  width: UISize.width(100),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: UISize.width(16)),
                                child: Text(
                                  "${state.firestoreUserResponse.firstName} ${state.firestoreUserResponse.lastName}",
                                  style: StyleText.nunitoBold.copyWith(
                                      color: UIColors.darkGray,
                                      fontSize: UISize.fontSize(20)),
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: UISize.width(16)),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Card(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      UISize.width(16)),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        state
                                                            .firestoreUserResponse
                                                            .myElections
                                                            .length
                                                            .toString(),
                                                        style: StyleText
                                                            .nunitoBold
                                                            .copyWith(
                                                                fontSize: UISize
                                                                    .fontSize(
                                                                        20),
                                                                color: UIColors
                                                                    .darkGray),
                                                      ),
                                                      Text(
                                                        "My Elections",
                                                        style: StyleText
                                                            .ralewayMedium
                                                            .copyWith(
                                                                fontSize: UISize
                                                                    .fontSize(
                                                                        12),
                                                                color: UIColors
                                                                    .darkGray),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Card(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      UISize.width(16)),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        state
                                                            .firestoreUserResponse
                                                            .participatedElections
                                                            .length
                                                            .toString(),
                                                        style: StyleText
                                                            .nunitoBold
                                                            .copyWith(
                                                                fontSize: UISize
                                                                    .fontSize(
                                                                        20),
                                                                color: UIColors
                                                                    .darkGray),
                                                      ),
                                                      Text(
                                                        "Participated Elections",
                                                        style: StyleText
                                                            .ralewayMedium
                                                            .copyWith(
                                                                fontSize: UISize
                                                                    .fontSize(
                                                                        12),
                                                                color: UIColors
                                                                    .darkGray),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          );
                        } else {
                          return Text("Some Error");
                        }
                      }),
                ],
              ),
              PostContainer(
                isOfProfile: true,
                profileId: widget.userId,
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _menu() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Edit Profile",
              style: StyleText.ralewayMedium.copyWith(
                  color: UIColors.darkGray, fontSize: UISize.fontSize(14)),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Log Out",
              style: StyleText.ralewayMedium.copyWith(
                  color: UIColors.darkGray, fontSize: UISize.fontSize(14)),
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 1) {
            print("Edit");
          } else {
            final ConfigurationService configurationService =
                ConfigurationService();
            final bool dbCleared = await configurationService.clearDB();
            dbCleared
                ? ExtendedNavigator.of(context)
                    .pushReplacementNamed(Routes.getStartedScreen)
                : Toast().showToast(
                    context: context,
                    title: "Error",
                    message: "Error when logging out!");
          }
        },
        icon: Icon(Icons.more_vert),
        offset: Offset(0, 100),
      );
}
