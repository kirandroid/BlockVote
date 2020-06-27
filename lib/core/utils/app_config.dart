import 'package:evoting/core/utils/contract_parser.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class AppConfig {
  var apiUrl = "http://192.168.1.12:8545";
  // final String apiUrl =
  //     "https://ropsten.infura.io/v3/759c8e94cb37497a9218009e21542fb7";

  // final Web3Client ethClient =
  //     Web3Client(AppConfig().apiUrl, AppConfig().httpClient);

  Web3Client ethClient() {
    final Client httpClient = Client();

    return Web3Client(apiUrl, httpClient);
  }

  static Future<DeployedContract> get contractAddress async {
    final DeployedContract contract = await ContractParser.fromAssets(
        "0x88140A3A1A777f09aC3Feef8b39b8BFf6D1eE68e");
    return contract;
  }
}
