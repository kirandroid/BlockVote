import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/empty_screen.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:web3dart/credentials.dart';

class VoterTab extends StatefulWidget {
  final FetchAnElectionCompleted electionResponse;
  final EthereumAddress loggedInUser;

  const VoterTab({this.electionResponse, this.loggedInUser});
  @override
  _VoterTabState createState() => _VoterTabState();
}

class _VoterTabState extends State<VoterTab> {
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: UISize.width(20), left: UISize.width(20)),
                    child: Text("Pending Voters",
                        style: StyleText.nunitoBold.copyWith(
                            color: UIColors.darkGray,
                            letterSpacing: 1,
                            fontSize: UISize.fontSize(16))),
                  ),
                  widget.electionResponse.election.pendingVoter.length == 0
                      ? EmptyScreen(
                          emptyMsg: "No Pending Voters",
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: widget
                                .electionResponse.election.pendingVoter.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 8,
                                    left: UISize.width(20),
                                    right: UISize.width(20)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: UIColors.primaryWhite,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ListTile(
                                          title: Text(
                                            widget.electionResponse.election
                                                .pendingVoter[index]
                                                .toString(),
                                            style: StyleText.nunitoSemiBold
                                                .copyWith(
                                                    fontSize:
                                                        UISize.fontSize(12),
                                                    color: UIColors.darkGray),
                                          ),
                                          trailing: widget.electionResponse
                                                      .election.creatorId ==
                                                  widget.loggedInUser
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.greenAccent
                                                          .withOpacity(0.7)),
                                                  child: Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      onTap: () {
                                                        sl<ElectionDetailBloc>()
                                                            .add(ApproveVoter(
                                                                electionId: widget
                                                                    .electionResponse
                                                                    .election
                                                                    .electionId,
                                                                voterId: widget
                                                                    .electionResponse
                                                                    .election
                                                                    .pendingVoter[index]));
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                          "Accept",
                                                          style: StyleText
                                                              .ralewaySemiBold
                                                              .copyWith(
                                                                  fontSize: UISize
                                                                      .fontSize(
                                                                          14),
                                                                  color: UIColors
                                                                      .darkGray),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: 0,
                                                ),
                                        ),
                                      ),
                                    ),
                                    // IconButton(icon: Icon(Icons.done), onPressed: () {})
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: UISize.width(20), left: UISize.width(20)),
                    child: Text("Approved Voters",
                        style: StyleText.nunitoBold.copyWith(
                            color: UIColors.darkGray,
                            letterSpacing: 1,
                            fontSize: UISize.fontSize(16))),
                  ),
                  widget.electionResponse.election.approvedVoter.length == 0
                      ? EmptyScreen(
                          emptyMsg: "No Approved Voters",
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: widget
                                .electionResponse.election.approvedVoter.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 8,
                                    left: UISize.width(20),
                                    right: UISize.width(20)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: UIColors.primaryWhite,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ListTile(
                                          title: Text(
                                            widget.electionResponse.election
                                                .approvedVoter[index]
                                                .toString(),
                                            style: StyleText.nunitoSemiBold
                                                .copyWith(
                                                    fontSize:
                                                        UISize.fontSize(12),
                                                    color: UIColors.darkGray),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // IconButton(icon: Icon(Icons.done), onPressed: () {})
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageIndicator(
            layout: PageIndicatorLayout.SCALE,
            activeColor: UIColors.primaryDarkTeal,
            color: UIColors.primaryDarkTeal,
            size: UISize.width(8.0),
            controller: _controller,
            space: UISize.width(5.0),
            count: 2,
          ),
        ),
      ],
    ));
  }
}
