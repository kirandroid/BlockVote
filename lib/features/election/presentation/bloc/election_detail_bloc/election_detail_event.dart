part of 'election_detail_bloc.dart';

@immutable
abstract class ElectionDetailEvent {}

class FetchAnElection implements ElectionDetailEvent {
  final BigInt electionId;
  FetchAnElection({@required this.electionId});
}

class JoinAnElection implements ElectionDetailEvent {
  final EthereumAddress loggedInUser;
  final BigInt electionId;
  final BuildContext context;
  final List<dynamic> voterList;

  JoinAnElection(
      {this.electionId, this.loggedInUser, this.context, this.voterList});
}
