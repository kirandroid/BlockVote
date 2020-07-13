import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/custom_dialog.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:evoting/features/election/presentation/pages/tab/election_tab.dart';
import 'package:evoting/features/election/presentation/pages/tab/result_tab.dart';
import 'package:evoting/features/election/presentation/pages/tab/voter_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/web3dart.dart';

class ElectionDetailScreen extends StatefulWidget {
  final String electionId;

  const ElectionDetailScreen({@required this.electionId});
  @override
  _ElectionDetailScreenState createState() => _ElectionDetailScreenState();
}

class _ElectionDetailScreenState extends State<ElectionDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  EthereumAddress loggedInUser;
  ElectionDetailBloc _electionDetailBloc = sl<ElectionDetailBloc>();
  @override
  void initState() {
    getAnElection();
    getLoggedInUser();
    super.initState();
  }

  void getLoggedInUser() async {
    final EthereumAddress loggedInUserKey = await AppConfig.loggedInUserKey;
    setState(() {
      loggedInUser = loggedInUserKey;
    });
  }

  void getAnElection() {
    _electionDetailBloc.add(FetchAnElection(electionId: widget.electionId));
  }

  @mustCallSuper
  void dispose() async {
    super.dispose();
    await _electionDetailBloc.drain();
    _electionDetailBloc.close();
  }

  Future<bool> goBack() {
    sl<ElectionListBloc>().add(GetAllElection());
    Navigator.pop(context);
  }

  void generateQR(String electionId) {
    CustomDialog(
        context: context,
        title: "Election QRCode",
        buttonTitle: "Okay",
        customWidget: QrImage(
          data: electionId,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: goBack,
        child: Scaffold(
            body: BlocBuilder<ElectionDetailBloc, ElectionDetailState>(
                bloc: this._electionDetailBloc,
                builder: (BuildContext context, ElectionDetailState state) {
                  if (state is FetchElectionLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FetchAnElectionCompleted) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                              height: UISize.width(100),
                              imageUrl: AppConfig().imageUrlFormat(
                                  folderName: "ElectionCover",
                                  imageName: state.election.electionCover),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => ShimmerEffect(
                                height: UISize.width(100),
                              ),
                              errorWidget: (context, url, error) =>
                                  ShimmerEffect(
                                height: UISize.width(100),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: UISize.width(100),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                bottom: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    size: 40,
                                    color: UIColors.primaryWhite,
                                  ),
                                  onPressed: goBack,
                                )),
                            Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.select_all,
                                    size: 30,
                                    color: UIColors.primaryWhite,
                                  ),
                                  onPressed: () =>
                                      generateQR(state.election.electionId),
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UISize.width(20),
                              vertical: UISize.width(10)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.election.electionName,
                                    style: StyleText.ralewayBold.copyWith(
                                        letterSpacing: 1,
                                        color: UIColors.darkGray,
                                        fontSize: UISize.fontSize(14)),
                                  ),
                                  loggedInUser == state.election.creatorId
                                      ? Container()
                                      : RaisedButton(
                                          color: state.joinButtonColor,
                                          onPressed: state.election.status
                                                      .shouldWarn ||
                                                  state.election.pendingVoter
                                                      .contains(loggedInUser) ||
                                                  state.election.approvedVoter
                                                      .contains(loggedInUser)
                                              ? () {
                                                  Toast().showToast(
                                                      context: context,
                                                      title: "Error",
                                                      message:
                                                          "Cannot join the election");
                                                }
                                              : () {
                                                  _electionDetailBloc.add(
                                                      JoinAnElection(
                                                          context: context,
                                                          electionId: state
                                                              .election
                                                              .electionId,
                                                          loggedInUser:
                                                              loggedInUser,
                                                          voterList: state
                                                              .election
                                                              .pendingVoter));
                                                },
                                          child: Text(
                                            state.joinButtonText,
                                            style: StyleText.ralewayBold
                                                .copyWith(
                                                    letterSpacing: 1,
                                                    color:
                                                        UIColors.primaryWhite,
                                                    fontSize:
                                                        UISize.fontSize(14)),
                                          )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: UISize.width(35),
                          color: UIColors.primaryWhite,
                          alignment: Alignment.center,
                          child: TabBar(
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 3,
                            controller: _tabController,
                            unselectedLabelColor: UIColors.mediumGray,
                            labelColor: UIColors.primaryDarkTeal,
                            labelStyle: StyleText.ralewayMedium
                                .copyWith(fontSize: UISize.fontSize(12)),
                            unselectedLabelStyle: StyleText.ralewayMedium
                                .copyWith(fontSize: UISize.fontSize(12)),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    width: 3.0,
                                    color: UIColors.primaryDarkTeal),
                                insets: EdgeInsets.symmetric(
                                    horizontal: UISize.width(16))),
                            tabs: [
                              Tab(
                                  child: Text(
                                "Voters",
                              )),
                              Tab(
                                  child: Text(
                                "Election",
                              )),
                              Tab(
                                  child: Text(
                                "Result",
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: <Widget>[
                              VoterTab(
                                electionResponse: state,
                                loggedInUser: loggedInUser,
                              ),
                              ElectionTab(
                                electionResponse: state,
                                loggedInUser: loggedInUser,
                              ),
                              ResultTab(
                                electionResponse: state,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is FetchElectionError) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      ),
    );
  }
}
