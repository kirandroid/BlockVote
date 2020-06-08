import 'dart:async';
import 'package:web3dart/web3dart.dart';

abstract class IContractService {
  Future<EtherAmount> getEthBalance(EthereumAddress from);
  Future<void> dispose();
}

class ContractService implements IContractService {
  ContractService(this.client, this.contract);

  final Web3Client client;
  final DeployedContract contract;

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await client.getBalance(from);
  }

  Future<void> dispose() async {
    await client.dispose();
  }
}
