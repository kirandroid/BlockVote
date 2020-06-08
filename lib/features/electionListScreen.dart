import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class ElectionListScreen extends StatefulWidget {
  Web3Client client;
  Credentials credentials;
  DeployedContract contract;
  ElectionListScreen({this.client, this.contract, this.credentials});
  @override
  _ElectionListScreenState createState() => _ElectionListScreenState();
}

class _ElectionListScreenState extends State<ElectionListScreen> {
  List elections = [];
  TextEditingController electionNameController = TextEditingController();
  BigInt count = BigInt.from(0);
  StreamSubscription<FilterEvent> countEvent;
  @override
  void initState() {
    getElections();
    super.initState();
  }

  @override
  void dispose() {
    widget.client.dispose();
    countEvent.asFuture();
    countEvent.cancel();
    super.dispose();
  }

  void getElections() async {
    final getElections = widget.contract.function('getAllElections');
    await widget.client.call(
        contract: widget.contract,
        function: getElections,
        params: []).then((value) {
      setState(() {
        elections = value;
      });
    });

    final getCount = widget.contract.function('count');
    await widget.client.call(
        contract: widget.contract,
        function: getCount,
        params: []).then((value) {
      setState(() {
        count = value.first;
      });
    });

    final countEventFunc = widget.contract.event('ElectionResult');
    countEvent = widget.client
        .events(FilterOptions.events(
            contract: widget.contract, event: countEventFunc))
        .listen((event) {
      setState(() {
        final decoded = countEventFunc.decodeResults(event.topics, event.data);
        final value = decoded[0] as BigInt;
        count = value;
      });
    });
  }

  void increaseCount() async {
    final eventCount = widget.contract.function('eventCount');
    await widget.client.sendTransaction(
        widget.credentials,
        Transaction.callContract(
            contract: widget.contract, function: eventCount, parameters: []));
  }

  void createElection(String name) async {
    final createElection = widget.contract.function('create');

    await widget.client
        .sendTransaction(
            widget.credentials,
            Transaction.callContract(
                contract: widget.contract,
                function: createElection,
                parameters: [name]))
        .then((_) => getElections());
  }

  void deleteElection(BigInt id) async {
    final deleteElection = widget.contract.function('destroy');

    await widget.client
        .sendTransaction(
            widget.credentials,
            Transaction.callContract(
                contract: widget.contract,
                function: deleteElection,
                parameters: [id]))
        .then((_) => getElections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextField(
            controller: electionNameController,
          ),
          RaisedButton(
            onPressed: () {
              createElection(electionNameController.text);
            },
            child: Text("Add"),
          ),
          Text(count.toString()),
          Expanded(
            child: elections.length <= 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: elections.first.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(elections.first[index][1].toString()),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteElection(elections.first[index][0]);
                            }),
                      );
                    }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          increaseCount();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
