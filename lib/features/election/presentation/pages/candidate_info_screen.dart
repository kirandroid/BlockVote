import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/presentation/bloc/candidate_info_bloc/candidate_info_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateInfoScreen extends StatefulWidget {
  final String candidateId;

  CandidateInfoScreen({@required this.candidateId});
  @override
  _CandidateInfoScreenState createState() => _CandidateInfoScreenState();
}

class _CandidateInfoScreenState extends State<CandidateInfoScreen> {
  @override
  void initState() {
    sl<CandidateInfoBloc>()
        .add(FetchCandidate(candidateId: widget.candidateId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<CandidateInfoBloc, CandidateInfoState>(
          bloc: sl<CandidateInfoBloc>(),
          builder: (context, state) {
            if (state is CandidateInfoLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CandidateInfoCompleted) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.candidate.candidateName),
                      Text(
                          "${state.candidate.voter.length.toString()} People Voted"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.candidate.voter.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            color: UIColors.lightGray,
                            child: ListTile(
                              title:
                                  Text(state.candidate.voter[index].toString()),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            } else if (state is CandidateInfoError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
