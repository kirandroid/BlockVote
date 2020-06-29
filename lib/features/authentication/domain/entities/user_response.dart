import 'package:web3dart/web3dart.dart';

class UserResponse {
  EthereumAddress userId;
  String firstName;
  String lastName;

  UserResponse({this.userId, this.firstName, this.lastName});
  UserResponse.fromMap(List data)
      : userId = data[0],
        firstName = data[1],
        lastName = data[2];
}
