import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/presentation/bloc/election_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  ElectionBloc _electionBloc;
  @override
  void initState() {
    _electionBloc = sl<ElectionBloc>();
    getAllElection();
    super.initState();
  }

  void getAllElection() async {
    _electionBloc.add(GetAllElection());
  }

  @override
  void dispose() {
    _electionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ElectionBloc>(
        create: (context) => ElectionBloc(),
        child: BlocBuilder<ElectionBloc, ElectionState>(
            bloc: this._electionBloc,
            builder: (BuildContext context, ElectionState state) {
              if (state is ElectionLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ElectionCompleted) {
                return ListView.builder(
                    itemCount: state.allElection.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/blockvote05.appspot.com/o/ElectionCover%2F${state.allElection[index].electionCover}?alt=media",
                          height: 100,
                          width: 100,
                        ),
                        title: Text(state.allElection[index].electionName),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // deleteElection(elections.first[index][0]);
                            }),
                      );
                    });
              } else if (state is ElectionError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else {
                return Center(
                  child: Text("Some Error occurred"),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ExtendedNavigator.of(context).pushNamed(Routes.createElectionScreen);
        },
        label: Text("Create Election"),
      ),
    );
  }
}
