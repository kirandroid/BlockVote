import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/custom_dialog.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  ElectionListBloc _electionBloc = sl<ElectionListBloc>();
  TextEditingController _passwordController = TextEditingController();
  bool _validPasswordField = true;

  @override
  void initState() {
    getAllElection();
    super.initState();
  }

  void getAllElection() async {
    sl<ElectionListBloc>().add(GetAllElection());
  }

  @mustCallSuper
  void dispose() async {
    super.dispose();
    await _electionBloc.drain();
    _electionBloc.close();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: UISize.width(20),
            left: UISize.width(20),
            right: UISize.width(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "ALL ELECTIONS",
                  style: StyleText.nunitoMedium.copyWith(
                      letterSpacing: 1,
                      fontSize: UISize.fontSize(20),
                      color: UIColors.darkGray),
                ),
                RaisedButton(
                    color: UIColors.primaryDarkTeal,
                    onPressed: () {
                      ExtendedNavigator.of(context)
                          .pushNamed(Routes.createElectionScreen);
                    },
                    child: Text(
                      "Create Election",
                      style: StyleText.ralewaySemiBold.copyWith(
                        color: UIColors.primaryWhite,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocProvider<ElectionListBloc>(
                create: (context) => ElectionListBloc(),
                child: BlocBuilder<ElectionListBloc, ElectionListState>(
                    bloc: this._electionBloc,
                    builder: (BuildContext context, ElectionListState state) {
                      if (state is ElectionListLoading) {
                        return ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: UISize.width(14)),
                                child: ShimmerEffect(
                                  height: UISize.width(100),
                                ),
                              );
                            });
                      } else if (state is ElectionListCompleted) {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: state.allElection.length,
                            itemBuilder: (context, index) {
                              ElectionResponse election =
                                  state.allElection[index];
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: UISize.width(14)),
                                child: Card(
                                  child: InkWell(
                                    onTap: () async {
                                      final EthereumAddress loggedInUserKey =
                                          await AppConfig.loggedInUserKey;
                                      if (election.creatorId ==
                                          loggedInUserKey) {
                                        ExtendedNavigator.of(context).pushNamed(
                                            Routes.electionDetailScreen,
                                            arguments:
                                                ElectionDetailScreenArguments(
                                                    electionId:
                                                        election.electionId));
                                      } else if (election.pendingVoter
                                          .contains(loggedInUserKey)) {
                                        ExtendedNavigator.of(context).pushNamed(
                                            Routes.electionDetailScreen,
                                            arguments:
                                                ElectionDetailScreenArguments(
                                                    electionId:
                                                        election.electionId));
                                      } else {
                                        election.hasPassword
                                            ? CustomDialog(
                                                context: context,
                                                title: "Password Required!",
                                                customWidget:
                                                    passwordTextField(),
                                                buttonTitle: "Okay",
                                                customSecondButton: false,
                                                onPressed: () {
                                                  _passwordController
                                                          .text.isNotEmpty
                                                      ? checkPassword(
                                                          electionPassword:
                                                              election.password,
                                                          electionId: election
                                                              .electionId)
                                                      : null;
                                                })
                                            : ExtendedNavigator.of(context)
                                                .pushNamed(
                                                    Routes.electionDetailScreen,
                                                    arguments:
                                                        ElectionDetailScreenArguments(
                                                            electionId: election
                                                                .electionId));
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            CachedNetworkImage(
                                              height: UISize.width(100),
                                              imageUrl: AppConfig()
                                                  .imageUrlFormat(
                                                      folderName:
                                                          "ElectionCover",
                                                      imageName: election
                                                          .electionCover),
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  ShimmerEffect(
                                                height: UISize.width(100),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      ShimmerEffect(
                                                height: UISize.width(100),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: UISize.width(100),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            election.hasPassword
                                                ? Positioned(
                                                    right: 8,
                                                    top: 8,
                                                    child: Container(
                                                      height: UISize.width(30),
                                                      width: UISize.width(30),
                                                      child: Icon(
                                                        Icons.lock,
                                                        size: 18,
                                                        color: UIColors
                                                            .primaryDarkTeal,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: UIColors
                                                              .primaryWhite),
                                                    ),
                                                  )
                                                : Container(),
                                            Positioned(
                                              left: 8,
                                              top: 8,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                child: Text(
                                                  election.status.status,
                                                  style: StyleText.ralewayBold
                                                      .copyWith(
                                                          letterSpacing: 1,
                                                          color: UIColors
                                                              .primaryWhite,
                                                          fontSize:
                                                              UISize.fontSize(
                                                                  12)),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: election
                                                        .status.statusColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(election.electionName),
                                                  Text(
                                                      "${election.formattedStartDate} - ${election.formattedEndDate}")
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${election.candidates.length} Candidates"),
                                                  Text(
                                                      "Created by ${election.creatorName}"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else if (state is ElectionError) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: UISize.width(14)),
                                child: ShimmerEffect(
                                  height: UISize.width(100),
                                ),
                              );
                            });
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          // Container(
          //   margin: EdgeInsets.only(right: UISize.width(20)),
          //   height: UISize.width(46),
          //   width: UISize.width(46),
          //   decoration: BoxDecoration(
          //       color: UIColors.primaryDarkTeal, shape: BoxShape.circle),
          //   child: Material(
          //     type: MaterialType.transparency,
          //     child: InkWell(
          //       borderRadius: BorderRadius.circular(25),
          //       onTap: () {
          //         ExtendedNavigator.of(context)
          //             .pushNamed(Routes.userQRScannerPage);
          //       },
          //       child: Container(
          //         child: Icon(
          //           Icons.select_all,
          //           size: 18,
          //           color: UIColors.primaryWhite,
          //         ),
          //       ),
          //     ),
          //   ),
          // )

          FloatingActionButton(
        onPressed: () {
          ExtendedNavigator.of(context).pushNamed(Routes.userQRScannerPage);
        },
        child: Icon(
          Icons.select_all,
          size: 24,
          color: UIColors.primaryWhite,
        ),
      ),
    );
  }

  void checkPassword({String electionPassword, String electionId}) {
    String hashedPassword =
        AppConfig().hashPassword(password: _passwordController.text);
    if (hashedPassword == electionPassword) {
      _passwordController.clear();
      Navigator.of(context).pop();
      ExtendedNavigator.of(context).pushNamed(Routes.electionDetailScreen,
          arguments: ElectionDetailScreenArguments(electionId: electionId));
    } else {
      _passwordController.clear();
      CustomDialog(
          context: context,
          title: "Password Incorrect",
          message: "Please try again!",
          buttonTitle: "Okay",
          onPressed: () {
            Navigator.of(context).pop();
          });
    }
  }

  Widget passwordTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UISize.width(14)),
      child: TextField(
          controller: _passwordController,
          autofocus: false,
          style: StyleText.ralewayMedium.copyWith(
              color: UIColors.darkGray, fontSize: UISize.fontSize(14)),
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              errorText: !_validPasswordField
                  ? "Password is incorrect"
                  : _passwordController.text.isEmpty
                      ? "Enter a password!"
                      : null,
              hintText: "Password",
              hintStyle: StyleText.ralewayMedium
                  .copyWith(color: UIColors.darkGray.withOpacity(0.5)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: UIColors.primaryWhite)),
              prefixIcon: Container(
                width: 20,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.lock,
                  color: UIColors.primaryPink,
                  size: UISize.width(20),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: UIColors.darkGray.withOpacity(0.2))))),
    );
  }
}
