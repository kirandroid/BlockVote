import 'dart:convert';

import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/contract_parser.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';

class AppConfig {
  final String relayWallet =
      "b8277c118e2d1ee3ffbf94ed42bc158f144d863aa72d83ba9dc58e70334d2a3c";
  final String apiUrl = "http://192.168.1.13:8545";
  final String contractAddress = "0x1d02ae1964a3002b5DA0690562fCeF6fD3BcA683";
  // final String apiUrl =
  //     "https://ropsten.infura.io/v3/759c8e94cb37497a9218009e21542fb7";

  String imageUrlFormat({String imageName, String folderName}) {
    return "https://firebasestorage.googleapis.com/v0/b/blockvote05.appspot.com/o/$folderName%2F$imageName?alt=media";
  }

  String hashPassword({String password}) {
    List<int> bytes = utf8.encode(password);
    Digest hashedpassword = sha1.convert(bytes);
    return hashedpassword.toString();
  }

  static Future<Credentials> get txnCredential async {
    return await AppConfig()
        .ethClient()
        .credentialsFromPrivateKey(AppConfig().relayWallet);
  }

  Web3Client ethClient() {
    final Client httpClient = Client();

    return Web3Client(apiUrl, httpClient);
  }

  static Future<DeployedContract> get contract async {
    final DeployedContract contract =
        await ContractParser.fromAssets(AppConfig().contractAddress);
    return contract;
  }

  static Future<bool> runTransaction(
      {String functionName, List parameter}) async {
    final DeployedContract deployedContract =
        await ContractParser.fromAssets(AppConfig().contractAddress);
    final Credentials credentials = await AppConfig()
        .ethClient()
        .credentialsFromPrivateKey(AppConfig().relayWallet);

    final function = deployedContract.function(functionName);
    try {
      await AppConfig()
          .ethClient()
          .sendTransaction(
              credentials,
              Transaction.callContract(
                  maxGas: 10000000,
                  contract: deployedContract,
                  function: function,
                  parameters: parameter,
                  gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1)))
          .then((value) => print(value))
          .catchError((onError) {
        print(onError);
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<EthereumAddress> publicKeyFromSeed({String seedPhrase}) async {
    final ConfigurationService configurationService = ConfigurationService();
    final AddressService addressService = AddressService(configurationService);
    final String privateKey = addressService.getPrivateKey(seedPhrase);
    final EthereumAddress publicKey =
        await addressService.getPublicAddress(privateKey);

    return publicKey;
  }

  static Future<EthereumAddress> publicKeyFromPrivate(
      {String privateKey}) async {
    final ConfigurationService configurationService = ConfigurationService();
    final AddressService addressService = AddressService(configurationService);
    final EthereumAddress publicKey =
        await addressService.getPublicAddress(privateKey);

    return publicKey;
  }

  /// Get initial route name of the app.
  static Future<String> get initialRoute async {
    final ConfigurationService configurationService = ConfigurationService();
    final bool isLoggedIn = await configurationService.didSetupWallet();
    return isLoggedIn ? Routes.indexScreen : Routes.getStartedScreen;
  }

  static Future<EthereumAddress> get loggedInUserKey async {
    final ConfigurationService configurationService = ConfigurationService();

    final String privateKey = await configurationService.getPrivateKey();
    final EthereumAddress publicKey =
        await AppConfig.publicKeyFromPrivate(privateKey: privateKey);

    return publicKey;
  }
}
