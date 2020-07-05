import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionDetailScreen extends StatefulWidget {
  final BigInt electionId;

  const ElectionDetailScreen({@required this.electionId});
  @override
  _ElectionDetailScreenState createState() => _ElectionDetailScreenState();
}

class _ElectionDetailScreenState extends State<ElectionDetailScreen> {
  List<CandidateResponse> candidatesList = [];
  @override
  void initState() {
    getElectionDetail();
    super.initState();
  }

  void getElectionDetail() async {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);
    final getAnElection = contract.function('getAnElection');
    final getCandidate = contract.function('getCandidate');

    ElectionResponse electionResponse = ElectionResponse.fromMap(
        await AppConfig().ethClient().call(
            contract: contract,
            function: getAnElection,
            params: [widget.electionId]));

    for (var i = 0; i < electionResponse.candidates.length; i++) {
      String candidateId = electionResponse.candidates[i];
      CandidateResponse candidateResponse = CandidateResponse.fromMap(
          await AppConfig().ethClient().call(
              contract: contract,
              function: getCandidate,
              params: [candidateId]));
      setState(() {
        candidatesList.add(candidateResponse);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: candidatesList.length,
          itemBuilder: (context, index) {
            if (candidatesList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListTile(
                title: Text(candidatesList[index].candidateName),
                leading: Image.network(
                  AppConfig().imageUrlFormat(
                      folderName: "ElectionCover",
                      imageName: candidatesList[index].candidateImage),
                  height: 100,
                  width: 100,
                ),
              );
            }
          }),
    );
  }
}
