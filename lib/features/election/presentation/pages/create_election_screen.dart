import 'dart:io';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/presentation/bloc/create_election_bloc/create_election_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/calender_popup_view.dart';
import 'package:evoting/core/widgets/election_cover_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateElectionScreen extends StatefulWidget {
  @override
  _CreateElectionScreenState createState() => _CreateElectionScreenState();
}

class _CreateElectionScreenState extends State<CreateElectionScreen> {
  File electionCover;
  bool hasPassword = false;
  CreateElectionBloc _createElectionBloc = sl<CreateElectionBloc>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  String showDateFrom = "--";
  String showDateTo = "--";

  List<CandidateResponse> candidates = [];

  TextEditingController electionNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController candidateController = TextEditingController();

  @override
  void dispose() {
    _createElectionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: UIColors.darkGray,
              ),
              onPressed: () {
                ExtendedNavigator.of(context).pop();
              }),
          title: Text(
            "CREATE NEW ELECTION",
            style: StyleText.nunitoRegular.copyWith(
                color: UIColors.darkGray,
                fontSize: UISize.fontSize(16),
                letterSpacing: 2.0),
          ),
        ),
        body: BlocConsumer(
            bloc: this._createElectionBloc,
            listener: (BuildContext context, CreateElectionState state) {
              if (state is CreateElectionCompleted) {
                sl<ElectionListBloc>().add(GetAllElection());
                ExtendedNavigator.of(context).pop();
              }
            },
            builder: (BuildContext context, CreateElectionState state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: UISize.width(20),
                      left: UISize.width(20),
                      right: UISize.width(20)),
                  child: Column(
                    children: [
                      ElectionCoverImagePicker(
                        listener: (File file) {
                          this.electionCover = file;
                        },
                      ),
                      TextField(
                          controller: electionNameController,
                          autofocus: false,
                          style: StyleText.ralewayMedium.copyWith(
                              color: UIColors.darkGray,
                              fontSize: UISize.fontSize(14)),
                          textInputAction: TextInputAction.done,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              hintText: "Election Name",
                              hintStyle: StyleText.ralewayMedium.copyWith(
                                  color: UIColors.darkGray.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: UIColors.primaryWhite)),
                              prefixIcon: Container(
                                width: 20,
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.accessibility_new,
                                  color: UIColors.primaryPink,
                                  size: UISize.width(20),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: UIColors.darkGray
                                          .withOpacity(0.2))))),
                      Row(
                        children: [
                          Text(
                            "Password?",
                            style: StyleText.ralewayRegular.copyWith(
                                color: UIColors.darkGray,
                                fontSize: UISize.fontSize(12)),
                          ),
                          Switch(
                            value: hasPassword,
                            onChanged: (value) {
                              setState(() {
                                hasPassword = value;
                              });
                            },
                            activeTrackColor: UIColors.primaryDarkTeal,
                            activeColor: UIColors.primaryTeal,
                          ),
                          Expanded(
                            child: TextField(
                                controller: passwordController,
                                enabled: hasPassword,
                                autofocus: false,
                                style: StyleText.ralewayMedium.copyWith(
                                    color: UIColors.darkGray,
                                    fontSize: UISize.fontSize(14)),
                                textInputAction: TextInputAction.done,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: StyleText.ralewayMedium.copyWith(
                                        color:
                                            UIColors.darkGray.withOpacity(0.5)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: UIColors.primaryWhite)),
                                    prefixIcon: Container(
                                      width: 20,
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        hasPassword
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        color: hasPassword
                                            ? UIColors.primaryPink
                                            : UIColors.greyText,
                                        size: UISize.width(20),
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: UIColors.darkGray
                                                .withOpacity(0.2))))),
                          ),
                        ],
                      ),
                      electionDateWidget(),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: candidateController,
                                autofocus: false,
                                style: StyleText.ralewayMedium.copyWith(
                                    color: UIColors.darkGray,
                                    fontSize: UISize.fontSize(14)),
                                textInputAction: TextInputAction.done,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: "Candidate Name",
                                    hintStyle: StyleText.ralewayMedium.copyWith(
                                        color:
                                            UIColors.darkGray.withOpacity(0.5)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: UIColors.primaryWhite)),
                                    prefixIcon: Container(
                                      width: 20,
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        Icons.people,
                                        color: UIColors.primaryPink,
                                        size: UISize.width(20),
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: UIColors.darkGray
                                                .withOpacity(0.2))))),
                          ),
                          RaisedButton(
                            onPressed: () {
                              var uuid = new Uuid();
                              setState(() {
                                candidates.add(CandidateResponse(
                                    candidateId: uuid.v4(),
                                    candidateImage: "blockvote.png",
                                    candidateName: candidateController.text));
                                candidateController.clear();
                              });
                            },
                            color: UIColors.primaryPink,
                            child: Text(
                              "Add",
                              style: StyleText.nunitoBold.copyWith(
                                  color: UIColors.primaryWhite,
                                  fontSize: UISize.fontSize(14)),
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: candidates.length,
                          itemBuilder: (context, index) {
                            if (candidates.isEmpty) {
                              return Text(
                                "No Candidates Added",
                                style: StyleText.nunitoBold.copyWith(
                                    color: UIColors.darkGray,
                                    fontSize: UISize.fontSize(14)),
                              );
                            } else {
                              return ListTile(
                                title: Text(candidates[index].candidateName),
                              );
                            }
                          })
                    ],
                  ),
                ),
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.cloud_upload),
          label: Text("Submit"),
          onPressed: () {
            _createElectionBloc.add(CreateElection(
                electionName: electionNameController.text,
                electionPassword: passwordController.text,
                hasPassword: hasPassword,
                startDate: startDate,
                endDate: endDate,
                isActive: true,
                candidates: candidates,
                image: electionCover));
          },
        ),
      ),
    );
  }

  Widget electionDateWidget() {
    return Card(
      child: InkWell(
        onTap: () {
          showDemoDialog(context: context);
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(UISize.width(20.0),
                  UISize.width(10.0), UISize.width(20.0), 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "FROM",
                    style: StyleText.ralewayMedium.copyWith(
                        fontSize: UISize.fontSize(14),
                        color: UIColors.primaryPink),
                  ),
                  Text(
                    "TO",
                    style: StyleText.ralewayMedium.copyWith(
                        fontSize: UISize.fontSize(14),
                        color: UIColors.primaryPink),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(UISize.width(20)),
                    child: Text(
                      showDateFrom,
                      style: StyleText.ralewayMedium.copyWith(
                          fontSize: UISize.fontSize(14),
                          color: UIColors.darkGray),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: UIColors.primaryDarkTeal,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(UISize.width(20)),
                    child: Text(
                      showDateTo,
                      style: StyleText.ralewayMedium.copyWith(
                          fontSize: UISize.fontSize(14),
                          color: UIColors.darkGray),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
              showDateFrom = DateFormat('MMM dd,yyyy').format(startData);
              showDateTo = DateFormat('MMM dd,yyyy').format(endData);
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}
