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
