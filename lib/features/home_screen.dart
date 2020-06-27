import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/service/contract_service.dart';
import 'package:evoting/core/utils/eth_amount_formatter.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatefulWidget {
  final IAddressService addressService;
  final IConfigurationService configurationService;
  final IContractService contractService;
  HomeScreen(
      {this.addressService, this.configurationService, this.contractService});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String publicAddress = '';
  String privateAddress = '';
  BigInt amount;
  @override
  void initState() {
    _initFromMnemonic();
    super.initState();
  }

  void _initFromMnemonic() async {
    final entropyMnemonic = widget.configurationService.getMnemonic();
    final mnemonic = entropyMnemonic
        .then((value) => widget.addressService.entropyToMnemonic(value));
    mnemonic.then((value) => print("Mnemonic " + value));

    final privateKey =
        mnemonic.then((value) => widget.addressService.getPrivateKey(value));
    final address = await privateKey
        .then((value) => widget.addressService.getPublicAddress(value));

    setState(() {
      this.publicAddress = address.toString();
      privateKey.then((value) => this.privateAddress = value);
    });
    await fetchBalance();
  }

  Future<void> fetchBalance() async {
    final client = Web3Client(
        "https://ropsten.infura.io/v3/759c8e94cb37497a9218009e21542fb7",
        Client(),
        enableBackgroundIsolate: true);
    var ethBalance =
        await client.getBalance(EthereumAddress.fromHex(publicAddress));
    setState(() {
      this.amount = ethBalance.getInWei;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(publicAddress),
            Text(privateAddress),
            Text(EthAmountFormatter(amount).format())
          ],
        ),
      ),
    );
  }
}
