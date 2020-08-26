import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionTab extends StatefulWidget {
  final FetchAnElectionCompleted electionResponse;
  final EthereumAddress loggedInUser;

  const ElectionTab({this.electionResponse, this.loggedInUser});
  @override
  _ElectionTabState createState() => _ElectionTabState();
}

class _ElectionTabState extends State<ElectionTab> {
  int candidateIndex;
  String candidateId = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: UISize.width(20),
          right: UISize.width(20),
          top: UISize.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Election Candidates",
              style: StyleText.nunitoBold.copyWith(
                  color: UIColors.darkGray,
                  letterSpacing: 1,
                  fontSize: UISize.fontSize(16))),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.electionResponse.candidates.length,
              itemBuilder: (context, index) {
                CandidateResponse candidate =
                    widget.electionResponse.candidates[index];
                if (widget.electionResponse.candidates.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              candidateIndex = index;
                              candidateId = candidate.candidateId;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: candidateIndex == index
                                    ? UIColors.primaryDarkTeal
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topLeft: Radius.circular(8))),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Container(
                                    height: UISize.width(40),
                                    width: UISize.width(40),
                                    alignment: Alignment.center,
                                    child: Text(
                                      candidate.candidateName[0],
                                      style: StyleText.nunitoSemiBold.copyWith(
                                          color: UIColors.primaryWhite,
                                          fontSize: UISize.fontSize(20)),
                                    ),
                                    decoration: BoxDecoration(
                                        color: UIColors.primaryRed,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: UISize.width(20),
                                      bottom: UISize.width(20),
                                      left: UISize.width(10)),
                                  child: Text(
                                    candidate.candidateName,
                                    style: StyleText.ralewaySemiBold.copyWith(
                                        color: candidateIndex == index
                                            ? UIColors.primaryWhite
                                            : UIColors.darkGray,
                                        fontSize: UISize.fontSize(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () {
                            ExtendedNavigator.of(context).pushNamed(
                                Routes.candidateInfoScreen,
                                arguments: CandidateInfoScreenArguments(
                                    candidateId: candidate.candidateId));
                          })
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: UISize.width(50),
              child: widget.electionResponse.election.creatorId ==
                      widget.loggedInUser
                  ? Container()
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      child: Text(
                        "VOTE",
                        style: StyleText.ralewayBold.copyWith(
                            fontSize: UISize.fontSize(15), letterSpacing: 1),
                      ),
                      onPressed: widget.electionResponse.election.approvedVoter
                                  .contains(widget.loggedInUser) &&
                              widget.electionResponse.election.status.status ==
                                  'VOTING' &&
                              !widget.electionResponse.election.votedVoter
                                  .contains(widget.loggedInUser)
                          ? () {
                              sl<ElectionDetailBloc>().add(VoteCandidate(
                                  context: context,
                                  candidateId: candidateId,
                                  electionId: widget
                                      .electionResponse.election.electionId,
                                  voterId: widget.loggedInUser));
                            }
                          : () {
                              Toast().showToast(
                                  context: context,
                                  title: "Error",
                                  message: "User cannot vote now!");
                            },
                      color: UIColors.primaryDarkTeal,
                      elevation: 0,
                      textColor: UIColors.primaryWhite,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
