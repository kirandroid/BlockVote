import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_bloc.dart';
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
  ElectionBloc _electionBloc = sl<ElectionBloc>();
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
    _electionBloc.add(FetchAnElection(electionId: widget.electionId));
  }

  @mustCallSuper
  void dispose() async {
    super.dispose();
    await _electionBloc.drain();
    _electionBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        sl<ElectionBloc>().add(GetAllElection());
        Navigator.pop(context);
      },
      child: Scaffold(
          body: BlocBuilder<ElectionBloc, ElectionState>(
              bloc: this._electionBloc,
              builder: (BuildContext context, ElectionState state) {
                if (state is FetchElectionLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FetchAnElectionCompleted) {
                  return Column(
                    children: [
                      loggedInUser == state.election.creatorId
                          ? Container()
                          : FlatButton(
                              onPressed: () {
                                _electionBloc.add(JoinAnElection(
                                    context: context,
                                    electionId: state.election.electionId,
                                    loggedInUser: loggedInUser,
                                    voterList: state.election.voter));
                              },
                              child: Text("Join")),
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: state.election.voter.length,
                            itemBuilder: (context, index) {
                              EthereumAddress voter =
                                  state.election.voter[index];
                              if (state.election.voter.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListTile(
                                  title: Text(voter.toString()),
                                );
                              }
                            }),
                      ),
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: state.candidates.length,
                            itemBuilder: (context, index) {
                              CandidateResponse candidatesList =
                                  state.candidates[index];
                              if (state.candidates.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListTile(
                                  title: Text(candidatesList.candidateName),
                                  leading: Image.network(
                                    AppConfig().imageUrlFormat(
                                        folderName: "ElectionCover",
                                        imageName:
                                            candidatesList.candidateImage),
                                    height: 100,
                                    width: 100,
                                  ),
                                );
                              }
                            }),
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
