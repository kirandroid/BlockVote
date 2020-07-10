import 'package:web3dart/web3dart.dart';

class UserResponse {
  EthereumAddress userId;

  UserResponse({this.userId});
  UserResponse.fromMap(List data) : userId = data.first[0];
}
