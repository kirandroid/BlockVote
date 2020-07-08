part of 'candidate_info_bloc.dart';

@immutable
abstract class CandidateInfoEvent {}

class FetchCandidate implements CandidateInfoEvent {
  final String candidateId;

  FetchCandidate({this.candidateId});
}
