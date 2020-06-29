import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/contract_parser.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class AppConfig {
  final String relayWallet =
      "c234ee8c12935f5c11ee7762cf54216d3a38c662eb2666b86b7e20e6b0ea3f3f";
  final String apiUrl = "http://192.168.1.12:8545";
  final String contractAddress = "0xc8448de2b6a11fd8BaA55Cfe1d777CCEae26419C";
  // final String apiUrl =
  //     "https://ropsten.infura.io/v3/759c8e94cb37497a9218009e21542fb7";

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
      await AppConfig().ethClient().sendTransaction(
          credentials,
          Transaction.callContract(
              contract: deployedContract,
              function: function,
              parameters: parameter));
      return true;
    } catch (e) {
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
}
