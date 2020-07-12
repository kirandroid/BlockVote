part of 'election_detail_bloc.dart';

@immutable
abstract class ElectionDetailEvent {}

class FetchAnElection implements ElectionDetailEvent {
  final String electionId;
  FetchAnElection({@required this.electionId});
}

class JoinAnElection implements ElectionDetailEvent {
  final EthereumAddress loggedInUser;
  final String electionId;
  final BuildContext context;
  final List<dynamic> voterList;

  JoinAnElection(
      {this.electionId, this.loggedInUser, this.context, this.voterList});
}

class ApproveVoter implements ElectionDetailEvent {
  final EthereumAddress voterId;
  final String electionId;
  ApproveVoter({this.electionId, this.voterId});
}

class VoteCandidate implements ElectionDetailEvent {
  final EthereumAddress voterId;
  final String candidateId;
  final String electionId;
  final BuildContext context;

  VoteCandidate(
      {this.voterId, this.candidateId, this.electionId, this.context});
}
