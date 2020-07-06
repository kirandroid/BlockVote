part of 'election_bloc.dart';

abstract class ElectionState extends Equatable {
  const ElectionState();
}

//---------------All Election List State------------------
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

class ElectionError extends ElectionState {
  final String errorMessage;
  ElectionError({this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

//---------------All Election List State------------------

//---------------Create Election State--------------------
class CreateElectionLoading extends ElectionState {
  @override
  List<Object> get props => [];
}

class CreateElectionCompleted extends ElectionState {
  @override
  List<Object> get props => [];
}

class CreateElectionError extends ElectionState {
  final String errorMessage;
  CreateElectionError({this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
//---------------Create Election State--------------------

//---------------Fetch An Election State-------------------
class FetchElectionLoading extends ElectionState {
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

class FetchElectionError extends ElectionState {
  final String errorMessage;
  FetchElectionError({this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
//---------------Fetch An Election State-------------------
