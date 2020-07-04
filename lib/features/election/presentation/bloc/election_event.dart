part of 'election_bloc.dart';

abstract class ElectionEvent extends Equatable {
  const ElectionEvent();
}

class GetAllElection implements ElectionEvent {
  @override
  bool get stringify => true;

  @override
  List<Object> get props => throw UnimplementedError();
}
