// import 'dart:async';
// import 'package:evoting/core/service/configuration_service.dart';
// import 'package:evoting/core/utils/app_config.dart';
// import 'package:evoting/core/utils/contract_parser.dart';
// import 'package:http/http.dart';

// import 'package:flutter/material.dart';
// import 'package:web3dart/credentials.dart';
// import 'package:web3dart/web3dart.dart';

// class ElectionListScreen extends StatefulWidget {
//   @override
//   _ElectionListScreenState createState() => _ElectionListScreenState();
// }

// class _ElectionListScreenState extends State<ElectionListScreen> {
//   List elections = [];
//   TextEditingController electionNameController = TextEditingController();
//   BigInt count = BigInt.from(0);
//   StreamSubscription<FilterEvent> countEvent;
//   @override
//   void initState() {
//     getElections();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     countEvent.asFuture();
//     countEvent.cancel();
//     super.dispose();
//   }

//   void getElections() async {
//     final Client httpClient = Client();

//     Web3Client client = Web3Client("http://192.168.1.13:8545", httpClient);
//     final DeployedContract deployedContract = await ContractParser.fromAssets(
//         "0xb4f35e69d1Cae6a491F250B71Ed4fc0CEbF31740");

//     final Credentials credentials = await AppConfig()
//         .ethClient()
//         .credentialsFromPrivateKey(
//             "7aacfcb9320a4e039cfe7c3bffb349d3fff6350065bd729ada6143133f92e313");

//     final getElections = deployedContract.function('getAllPolls');
//     await client.call(
//         contract: deployedContract,
//         function: getElections,
//         params: []).then((value) {
//       setState(() {
//         elections = value;
//       });
//     });

//     final getCount = deployedContract.function('count');
//     await client.call(
//         contract: deployedContract,
//         function: getCount,
//         params: []).then((value) {
//       setState(() {
//         count = value.first;
//       });
//     });

//     final countEventFunc = deployedContract.event('ElectionResult');
//     countEvent = client
//         .events(FilterOptions.events(
//             contract: deployedContract, event: countEventFunc))
//         .listen((event) {
//       setState(() {
//         final decoded = countEventFunc.decodeResults(event.topics, event.data);
//         final value = decoded[0] as BigInt;
//         count = value;
//       });
//     });
//   }

//   void increaseCount() async {
//     final Client httpClient = Client();

//     Web3Client client = Web3Client("http://192.168.1.13:8545", httpClient);
//     final DeployedContract deployedContract = await ContractParser.fromAssets(
//         "0xb4f35e69d1Cae6a491F250B71Ed4fc0CEbF31740");

//     final Credentials credentials = await AppConfig()
//         .ethClient()
//         .credentialsFromPrivateKey(
//             "7aacfcb9320a4e039cfe7c3bffb349d3fff6350065bd729ada6143133f92e313");
//     final eventCount = deployedContract.function('eventCount');
//     await client.sendTransaction(
//         credentials,
//         Transaction.callContract(
//             contract: deployedContract, function: eventCount, parameters: []));
//   }

//   void createElection(String name) async {
//     final Client httpClient = Client();

//     Web3Client client = Web3Client("http://192.168.1.13:8545", httpClient);
//     final DeployedContract deployedContract = await ContractParser.fromAssets(
//         "0xb4f35e69d1Cae6a491F250B71Ed4fc0CEbF31740");

//     final Credentials credentials = await AppConfig()
//         .ethClient()
//         .credentialsFromPrivateKey(
//             "b8277c118e2d1ee3ffbf94ed42bc158f144d863aa72d83ba9dc58e70334d2a3c");

//     final ConfigurationService configurationService = ConfigurationService();
//     final String privateKey = await configurationService.getPrivateKey();
//     final EthereumAddress publicKey =
//         await AppConfig.publicKeyFromPrivate(privateKey: privateKey);
//     final createElection = deployedContract.function('createElection');

//     await client
//         .sendTransaction(
//             credentials,
//             Transaction.callContract(
//                 contract: deployedContract,
//                 function: createElection,
//                 maxGas: 10000000,
//                 parameters: [
//                   name,
//                   publicKey,
//                   "123456",
//                   true,
//                   BigInt.from(2345),
//                   BigInt.from(6585),
//                   true,
//                   ["sd", "ds"],
//                   "https://i.picsum.photos/id/800/536/354.jpg?hmac=VW0nKG7z_s-ANopnZfiYpCRz_PxyLNuLVATaFRiCcfc"
//                 ]))
//         .then((_) => getElections());
//   }

//   void deleteElection(BigInt id) async {
//     final Client httpClient = Client();

//     Web3Client client = Web3Client("http://192.168.1.13:8545", httpClient);
//     final DeployedContract deployedContract = await ContractParser.fromAssets(
//         "0xb4f35e69d1Cae6a491F250B71Ed4fc0CEbF31740");

//     final Credentials credentials = await AppConfig()
//         .ethClient()
//         .credentialsFromPrivateKey(
//             "7aacfcb9320a4e039cfe7c3bffb349d3fff6350065bd729ada6143133f92e313");
//     final deleteElection = deployedContract.function('destroy');

//     await client
//         .sendTransaction(
//             credentials,
//             Transaction.callContract(
//                 contract: deployedContract,
//                 function: deleteElection,
//                 parameters: [id]))
//         .then((_) => getElections());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           TextField(
//             controller: electionNameController,
//           ),
//           RaisedButton(
//             onPressed: () {
//               createElection(electionNameController.text);
//             },
//             child: Text("Add"),
//           ),
//           Text(count.toString()),
//           Expanded(
//             child: elections.length <= 0
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : ListView.builder(
//                     itemCount: elections.first.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(elections.first[index][1].toString()),
//                         trailing: IconButton(
//                             icon: Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             ),
//                             onPressed: () {
//                               deleteElection(elections.first[index][0]);
//                             }),
//                       );
//                     }),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           increaseCount();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
