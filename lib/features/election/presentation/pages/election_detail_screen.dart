import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/shimmerEffect.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

class ElectionDetailScreen extends StatefulWidget {
  final BigInt electionId;

  const ElectionDetailScreen({@required this.electionId});
  @override
  _ElectionDetailScreenState createState() => _ElectionDetailScreenState();
}

class _ElectionDetailScreenState extends State<ElectionDetailScreen> {
  EthereumAddress loggedInUser;
  ElectionDetailBloc _electionDetailBloc = sl<ElectionDetailBloc>();
  int candidateIndex;
  String candidateId = '';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                            errorWidget: (context, url, error) => ShimmerEffect(
                              height: UISize.width(100),
                            ),
                            imageBuilder: (context, imageProvider) => Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        color: state.election.pendingVoter
                                                .contains(loggedInUser)
                                            ? UIColors.primaryRed
                                            : UIColors.primaryGreen,
                                        onPressed: () {
                                          _electionDetailBloc.add(
                                              JoinAnElection(
                                                  context: context,
                                                  electionId:
                                                      state.election.electionId,
                                                  loggedInUser: loggedInUser,
                                                  voterList: state
                                                      .election.pendingVoter));
                                        },
                                        child: Text(
                                          state.election.pendingVoter
                                                  .contains(loggedInUser)
                                              ? "JOINED"
                                              : "JOIN",
                                          style: StyleText.ralewayBold.copyWith(
                                              letterSpacing: 1,
                                              color: UIColors.primaryWhite,
                                              fontSize: UISize.fontSize(14)),
                                        )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UISize.width(20)),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: UISize.width(20),
                                            left: UISize.width(20),
                                            right: UISize.width(20)),
                                        child: Text(
                                          "Pending",
                                          style: StyleText.nunitoBold.copyWith(
                                              color: UIColors.darkGray,
                                              letterSpacing: 1,
                                              fontSize: UISize.fontSize(18)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: state
                                                .election.pendingVoter.length,
                                            itemBuilder: (context, index) {
                                              EthereumAddress voter = state
                                                  .election.pendingVoter[index];
                                              if (state.election.pendingVoter
                                                  .isEmpty) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                            voter.toString()),
                                                      ),
                                                    ),
                                                    state.election.creatorId ==
                                                            loggedInUser
                                                        ? IconButton(
                                                            icon: Icon(
                                                                Icons.done),
                                                            onPressed: () {
                                                              _electionDetailBloc
                                                                  .add(ApproveVoter(
                                                                      electionId: state
                                                                          .election
                                                                          .electionId,
                                                                      voterId:
                                                                          voter));
                                                            })
                                                        : Container(),
                                                  ],
                                                );
                                              }
                                            }),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Approved",
                                              style: StyleText.nunitoBold
                                                  .copyWith(
                                                      color: UIColors.darkGray,
                                                      letterSpacing: 1,
                                                      fontSize:
                                                          UISize.fontSize(18)),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: state.election
                                                      .approvedVoter.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    EthereumAddress voter =
                                                        state.election
                                                                .approvedVoter[
                                                            index];
                                                    if (state
                                                        .election
                                                        .approvedVoter
                                                        .isEmpty) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else {
                                                      return ListTile(
                                                        title: Text(
                                                            voter.toString()),
                                                      );
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: UISize.width(20),
                                            left: UISize.width(20),
                                            right: UISize.width(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Candidates",
                                              style: StyleText.nunitoBold
                                                  .copyWith(
                                                      color: UIColors.darkGray,
                                                      letterSpacing: 1,
                                                      fontSize:
                                                          UISize.fontSize(18)),
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                _electionDetailBloc.add(
                                                    VoteCandidate(
                                                        candidateId:
                                                            candidateId,
                                                        electionId: state
                                                            .election
                                                            .electionId,
                                                        voterId: loggedInUser));
                                              },
                                              child: Text("VOTE"),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: state.candidates.length,
                                            itemBuilder: (context, index) {
                                              CandidateResponse candidate =
                                                  state.candidates[index];
                                              if (state.candidates.isEmpty) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            candidateIndex =
                                                                index;
                                                            candidateId =
                                                                candidate
                                                                    .candidateId;
                                                          });
                                                        },
                                                        child: Container(
                                                          color:
                                                              candidateIndex ==
                                                                      index
                                                                  ? UIColors
                                                                      .primaryDarkTeal
                                                                  : Colors
                                                                      .transparent,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Text(
                                                            candidate
                                                                .candidateName,
                                                            style: StyleText
                                                                .ralewaySemiBold
                                                                .copyWith(
                                                                    color: candidateIndex ==
                                                                            index
                                                                        ? UIColors
                                                                            .primaryWhite
                                                                        : UIColors
                                                                            .darkGray,
                                                                    fontSize: UISize
                                                                        .fontSize(
                                                                            14)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(Icons
                                                            .chevron_right),
                                                        onPressed: () {
                                                          ExtendedNavigator.of(
                                                                  context)
                                                              .pushNamed(
                                                                  Routes
                                                                      .candidateInfoScreen,
                                                                  arguments: CandidateInfoScreenArguments(
                                                                      candidateId:
                                                                          candidate
                                                                              .candidateId));
                                                        })
                                                  ],
                                                );
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
