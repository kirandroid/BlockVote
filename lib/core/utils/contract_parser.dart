import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';

class ContractParser {
  static Future<DeployedContract> fromAssets(String contractAddress) async {
    final contractJson =
        jsonDecode(await rootBundle.loadString('assets/Voting.json'));

    return DeployedContract(
        ContractAbi.fromJson(
            jsonEncode(contractJson["abi"]), contractJson["contractName"]),
        EthereumAddress.fromHex(contractAddress));
  }
}
