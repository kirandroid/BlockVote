part of 'election_detail_bloc.dart';

@immutable
abstract class ElectionDetailState {}

class ElectionDetailInitial extends ElectionDetailState {}

class FetchElectionLoading extends ElectionDetailState {}

class FetchAnElectionCompleted extends ElectionDetailState {
  final ElectionResponse election;
  final List<CandidateResponse> candidates;
  FetchAnElectionCompleted({this.election, this.candidates});
}

class FetchElectionError extends ElectionDetailState {
  final String errorMessage;
  FetchElectionError({this.errorMessage});
}
