import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/home/presentation/widgets/postContainer.dart';
import 'package:evoting/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProfileBloc _profileBloc = sl<ProfileBloc>();
  String loggedInUser;

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
    _profileBloc.add(FetchFirestoreUserProfile(context: context));
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
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "NEWSFEED",
          style: StyleText.ralewayRegular.copyWith(
              color: UIColors.darkGray,
              fontSize: UISize.fontSize(20),
              letterSpacing: 2.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(UISize.width(10), 0, UISize.width(10), 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: InkWell(
                  onTap: () {
                    ExtendedNavigator.of(context)
                        .pushNamed(Routes.createPostScreen);
                  },
                  child: Container(
                      padding: EdgeInsets.all(UISize.width(8)),
                      height: UISize.width(100),
                      child: BlocBuilder<ProfileBloc, ProfileState>(
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
                                    placeholder: (context, url) =>
                                        ShimmerEffect(
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
                                    "Want to share an update, ${state.firestoreUserResponse.firstName}?",
                                    style: StyleText.ralewayRegular.copyWith(
                                        color: UIColors.darkGray,
                                        fontSize: UISize.fontSize(12)),
                                  )
                                ],
                              );
                            }
                            return Container();
                          })),
                ),
              ),
              PostContainer(
                isOfProfile: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
