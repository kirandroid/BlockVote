part of 'election_bloc.dart';

abstract class ElectionEvent extends Equatable {
  const ElectionEvent();
}

class GetAllElection implements ElectionEvent {
  @override
  bool get stringify => true;

  @override
  List<Object> get props => throw UnimplementedError();
}

class CreateElection implements ElectionEvent {
  final String electionName;
  final String electionPassword;
  final bool hasPassword;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<CandidateResponse> candidates;
  final File image;

  CreateElection(
      {this.electionName,
      this.electionPassword,
      this.hasPassword,
      this.startDate,
      this.endDate,
      this.isActive,
      this.candidates,
      this.image});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        this.electionName,
        this.electionPassword,
        this.hasPassword,
        this.startDate,
        this.endDate,
        this.isActive,
        this.candidates,
        this.image
      ];
}

class FetchAnElection implements ElectionEvent {
  final BigInt electionId;
  FetchAnElection({@required this.electionId});
  @override
  bool get stringify => true;

  @override
  List<Object> get props => [this.electionId];
}

class JoinAnElection implements ElectionEvent {
  final EthereumAddress loggedInUser;
  final BigInt electionId;
  final BuildContext context;
  final List<dynamic> voterList;

  JoinAnElection(
      {this.electionId, this.loggedInUser, this.context, this.voterList});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [loggedInUser, electionId, context, voterList];
}
