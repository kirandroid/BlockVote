import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/route_guards.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:syncfusion_flutter_core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  await Hive.initFlutter();

  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgjITI3OzI9Mj00Mjg6ITI9EzQ+Mjo/fTA8Pg==");

  // Create storage
  final storage = new FlutterSecureStorage();
  var hasKeyBox = await Hive.openBox('hasKeyBox');
  if (!hasKeyBox.containsKey('hasKey')) {
    var key = Hive.generateSecureKey();
    hasKeyBox.put('hasKey', true);
    await storage.write(key: "encryptedBoxKey", value: key.toString());
  }

  final String initialRoute = await AppConfig.initialRoute;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (ctx, _) => ExtendedNavigator<Router>(
      router: Router(),
      guards: [AuthGuard()],
      initialRoute: initialRoute,
    ),
  ));
}

// class MyApp extends StatefulWidget {
//   Web3Client client;
//   Credentials credentials;
//   DeployedContract contract;
//   MyApp({this.client, this.contract, this.credentials});
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String testText = '';
//   String helloText = '';
//   BigInt bigNumber = BigInt.from(0);
//   TextEditingController numController = TextEditingController();
//   TextEditingController idController = TextEditingController();
//   List ids = [];

//   @override
//   void initState() {
//     getData();
//     getNumber();
//     getIds();
//     super.initState();
//   }

//   void getIds() async {
//     final getIds = widget.contract.function('getAll');
//     await widget.client.call(
//         contract: widget.contract, function: getIds, params: []).then((value) {
//       setState(() {
//         ids = value;
//       });
//     });
//   }

//   void setIds(int data) async {
//     final setIds = widget.contract.function('add');
//     await widget.client
//         .sendTransaction(
//             widget.credentials,
//             Transaction.callContract(
//                 contract: widget.contract,
//                 function: setIds,
//                 parameters: [BigInt.from(data)]))
//         .then((_) => getIds());
//   }

//   void getData() async {
//     final getName = widget.contract.function('testName');

//     await widget.client.call(
//         contract: widget.contract, function: getName, params: []).then((value) {
//       print(value.first);
//       setState(() {
//         testText = value.first;
//       });
//     }).catchError((onError, trace) {
//       print(onError);
//       print(trace);
//     });

//     final hello = widget.contract.function('hello');
//     await widget.client.call(
//         contract: widget.contract, function: hello, params: []).then((value) {
//       print(value.first);
//       setState(() {
//         helloText = value.first;
//       });
//     }).catchError((onError, trace) {
//       print(onError);
//       print(trace);
//     });
//   }

//   void getNumber() async {
//     final number = widget.contract.function('getNumber');
//     final getNumber = await widget.client
//         .call(contract: widget.contract, function: number, params: []);

//     setState(() {
//       bigNumber = BigInt.parse(getNumber.first.toString(), radix: 10);
//     });
//   }

//   void storeNumber(int data) async {
//     final store = widget.contract.function('store');
//     await widget.client
//         .sendTransaction(
//             widget.credentials,
//             Transaction.callContract(
//                 contract: widget.contract,
//                 function: store,
//                 parameters: [BigInt.from(data)]))
//         .then((_) => getNumber());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Builder(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             actions: <Widget>[
//               IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => ElectionListScreen(
//                               client: widget.client,
//                               contract: widget.contract,
//                               credentials: widget.credentials,
//                             )));
//                   })
//             ],
//           ),
//           body: Column(
//             children: <Widget>[
//               Text(testText),
//               Text(helloText),
//               Text(bigNumber.toString()),
//               TextField(
//                 controller: numController,
//               ),
//               RaisedButton(
//                 onPressed: () {
//                   storeNumber(int.parse(numController.text));
//                 },
//                 child: Text("Submit"),
//               ),
//               TextField(
//                 controller: idController,
//               ),
//               RaisedButton(
//                 onPressed: () {
//                   setIds(int.parse(idController.text));
//                 },
//                 child: Text("Add"),
//               ),
//               Expanded(
//                 child: ids.length <= 0
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : ListView.builder(
//                         itemCount: ids.first.length,
//                         itemBuilder: (context, index) {
//                           if (ids.first.length <= 0) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           return ListTile(
//                             title: Text(ids.first[index].toString()),
//                           );
//                         }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
