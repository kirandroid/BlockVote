import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

class ElectionResponse {
  final String electionId;
  final String electionName;
  final EthereumAddress creatorId;
  final String password;
  final bool hasPassword;
  final BigInt startDate;
  final BigInt endDate;
  final bool isActive;
  final List<dynamic> candidates;
  final String electionCover;
  final List<dynamic> pendingVoter;
  final List<dynamic> approvedVoter;
  List<dynamic> votedVoter;
  String formattedStartDate;
  String formattedEndDate;
  String creatorName;
  ElectionStatus status;

  ElectionResponse(
      {this.electionId,
      this.electionName,
      this.creatorId,
      this.password,
      this.hasPassword,
      this.startDate,
      this.endDate,
      this.isActive,
      this.candidates,
      this.electionCover,
      this.pendingVoter,
      this.approvedVoter,
      this.formattedStartDate,
      this.formattedEndDate,
      this.creatorName,
      this.status,
      this.votedVoter});

  ElectionResponse.fromMap(List data)
      : electionId = data.first[0],
        electionName = data.first[1],
        creatorId = data.first[2],
        password = data.first[3],
        hasPassword = data.first[4],
        startDate = data.first[5],
        endDate = data.first[6],
        isActive = data.first[7],
        candidates = data.first[8],
        electionCover = data.first[9],
        pendingVoter = data.first[10],
        approvedVoter = data.first[11];
}

class ElectionStatus {
  String status;
  Color statusColor;
  bool shouldWarn;
  String
      reason; //For showing in a dialog if the election is already finised or running
  ElectionStatus({this.status, this.reason, this.statusColor, this.shouldWarn});
}
