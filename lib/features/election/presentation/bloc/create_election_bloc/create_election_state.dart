part of 'create_election_bloc.dart';

@immutable
abstract class CreateElectionState {}

class CreateElectionInitial extends CreateElectionState {}

class CreateElectionLoading extends CreateElectionState {}

class CreateElectionCompleted extends CreateElectionState {
  final String electionId;
  CreateElectionCompleted({this.electionId});
}

class CreateElectionError extends CreateElectionState {
  final String errorMessage;
  CreateElectionError({this.errorMessage});
}
