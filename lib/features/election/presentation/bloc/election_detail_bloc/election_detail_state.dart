part of 'election_detail_bloc.dart';

@immutable
abstract class ElectionDetailState {}

class ElectionDetailInitial extends ElectionDetailState {}

class FetchElectionLoading extends ElectionDetailState {}

class FetchAnElectionCompleted extends ElectionDetailState {
  final ElectionResponse election;
  final List<CandidateResponse> candidates;
  final Color joinButtonColor;
  final String joinButtonText;
  FetchAnElectionCompleted(
      {this.election,
      this.candidates,
      this.joinButtonColor,
      this.joinButtonText});
}

class FetchElectionError extends ElectionDetailState {
  final String errorMessage;
  FetchElectionError({this.errorMessage});
}
