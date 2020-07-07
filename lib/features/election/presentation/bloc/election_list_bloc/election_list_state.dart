part of 'election_list_bloc.dart';

@immutable
abstract class ElectionListState {}

class ElectionListInitial extends ElectionListState {}

class ElectionListLoading extends ElectionListState {}

class ElectionListCompleted extends ElectionListState {
  final List<ElectionResponse> allElection;
  ElectionListCompleted({this.allElection});
}

class ElectionError extends ElectionListState {
  final String errorMessage;
  ElectionError({this.errorMessage});
}
