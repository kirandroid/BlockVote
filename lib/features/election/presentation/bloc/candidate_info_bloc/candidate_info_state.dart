part of 'candidate_info_bloc.dart';

@immutable
abstract class CandidateInfoState {}

class CandidateInfoInitial extends CandidateInfoState {}

class CandidateInfoLoading extends CandidateInfoState {}

class CandidateInfoCompleted extends CandidateInfoState {
  final CandidateResponse candidate;

  CandidateInfoCompleted({this.candidate});
}

class CandidateInfoError extends CandidateInfoState {
  final String errorMessage;

  CandidateInfoError({this.errorMessage});
}
