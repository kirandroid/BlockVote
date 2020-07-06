part of 'election_bloc.dart';

abstract class ElectionState extends Equatable {
  const ElectionState();
}

class ElectionInitial extends ElectionState {
  @override
  List<Object> get props => [];
}

class ElectionLoading extends ElectionState {
  @override
  List<Object> get props => [];
}

class ElectionCompleted extends ElectionState {
  final List<ElectionResponse> allElection;
  ElectionCompleted({this.allElection});
  @override
  List<Object> get props => [allElection];
}

class CreateElectionCompleted extends ElectionState {
  @override
  List<Object> get props => [];
}

class FetchAnElectionCompleted extends ElectionState {
  final ElectionResponse election;
  final List<CandidateResponse> candidates;
  FetchAnElectionCompleted({this.election, this.candidates});

  @override
  List<Object> get props => [this.election, this.candidates];
}

class ElectionError extends ElectionState {
  final String errorMessage;
  ElectionError({this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
