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

class ElectionError extends ElectionState {
  final String errorMessage;
  ElectionError({this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
