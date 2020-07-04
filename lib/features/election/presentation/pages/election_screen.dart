import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/contract_parser.dart';
import 'package:evoting/features/election/presentation/bloc/election_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

import 'package:http/http.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  ElectionBloc _electionBloc = ElectionBloc();
  @override
  void initState() {
    getAllElection();
    super.initState();
  }

  void getAllElection() async {
    _electionBloc.add(GetAllElection());
  }

  @override
  void dispose() {
    _electionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ElectionBloc>(
        create: (context) => ElectionBloc(),
        child: BlocBuilder<ElectionBloc, ElectionState>(
            bloc: this._electionBloc,
            builder: (BuildContext context, ElectionState state) {
              if (state is ElectionLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ElectionCompleted) {
                return ListView.builder(
                    itemCount: state.allElection.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.allElection[index].electionName),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // deleteElection(elections.first[index][0]);
                            }),
                      );
                    });
              } else if (state is ElectionError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else {
                return Center(
                  child: Text("Some Error occurred"),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ConfigurationService configurationService =
              ConfigurationService();

          final String privateKey = await configurationService.getPrivateKey();
          final EthereumAddress publicKey =
              await AppConfig.publicKeyFromPrivate(privateKey: privateKey);
          // final bool response = await AppConfig.runTransaction(
          //     functionName: 'createElection',
          //     parameter: [
          //       "Test Election",
          //       publicKey,
          //       "123456",
          //       true,
          //       BigInt.from(2345),
          //       BigInt.from(6585),
          //       true,
          //       ["sd", "ds"],
          //       [],
          //       "https://i.picsum.photos/id/800/536/354.jpg?hmac=VW0nKG7z_s-ANopnZfiYpCRz_PxyLNuLVATaFRiCcfc"
          //     ]);

          // print(response);

          final Client httpClient = Client();

          Web3Client client =
              Web3Client("http://192.168.1.13:8545", httpClient);
          final DeployedContract deployedContract =
              await ContractParser.fromAssets(
                  "0xe443Ab7c529267C94f501ba1D000364eF9d9EEc0");
          final createElection = deployedContract.function('createElection');

          final Credentials credentials = await AppConfig()
              .ethClient()
              .credentialsFromPrivateKey(
                  "b8277c118e2d1ee3ffbf94ed42bc158f144d863aa72d83ba9dc58e70334d2a3c");
          await client.sendTransaction(
              credentials,
              Transaction.callContract(
                  contract: deployedContract,
                  function: createElection,
                  maxGas: 10000000,
                  parameters: [
                    "Noice Election",
                    publicKey,
                    "123456",
                    true,
                    BigInt.from(2345),
                    BigInt.from(6585),
                    true,
                    ["sd", "ds"],
                    "https://i.picsum.photos/id/800/536/354.jpg?hmac=VW0nKG7z_s-ANopnZfiYpCRz_PxyLNuLVATaFRiCcfc"
                  ]));
          // .then((_) => getElections());
        },
        label: Text("Create Election"),
      ),
    );
  }
}
