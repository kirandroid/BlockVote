import 'package:cached_network_image/cached_network_image.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
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
                      // loggedInUser == state.election.creatorId
                      //     ? Container()
                      //     : FlatButton(
                      //         onPressed: () {
                      //           _electionBloc.add(JoinAnElection(
                      //               context: context,
                      //               electionId: state.election.electionId,
                      //               loggedInUser: loggedInUser,
                      //               voterList: state.election.voter));
                      //         },
                      //         child: Text("Join")),
                      // Flexible(
                      //   flex: 1,
                      //   child: ListView.builder(
                      //       itemCount: state.election.voter.length,
                      //       itemBuilder: (context, index) {
                      //         EthereumAddress voter =
                      //             state.election.voter[index];
                      //         if (state.election.voter.isEmpty) {
                      //           return Center(
                      //               child: CircularProgressIndicator());
                      //         } else {
                      //           return ListTile(
                      //             title: Text(voter.toString()),
                      //           );
                      //         }
                      //       }),
                      // ),
                      // Flexible(
                      //   flex: 1,
                      //   child: ListView.builder(
                      //       itemCount: state.candidates.length,
                      //       itemBuilder: (context, index) {
                      //         CandidateResponse candidatesList =
                      //             state.candidates[index];
                      //         if (state.candidates.isEmpty) {
                      //           return Center(
                      //               child: CircularProgressIndicator());
                      //         } else {
                      //           return ListTile(
                      //             title: Text(candidatesList.candidateName),
                      //             leading: Image.network(
                      //               AppConfig().imageUrlFormat(
                      //                   folderName: "ElectionCover",
                      //                   imageName:
                      //                       candidatesList.candidateImage),
                      //               height: 100,
                      //               width: 100,
                      //             ),
                      //           );
                      //         }
                      //       }),
                      // ),
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
