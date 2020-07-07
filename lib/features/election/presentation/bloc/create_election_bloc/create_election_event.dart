part of 'create_election_bloc.dart';

@immutable
abstract class CreateElectionEvent {}

class CreateElection implements CreateElectionEvent {
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
}
