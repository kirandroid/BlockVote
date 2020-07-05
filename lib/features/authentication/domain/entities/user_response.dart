import 'package:web3dart/web3dart.dart';

class UserResponse {
  EthereumAddress userId;
  bool voted;
  String firstName;
  String lastName;

  UserResponse({this.userId, this.firstName, this.lastName});
  UserResponse.fromMap(List data)
      : userId = data.first[0],
        voted = data.first[1],
        firstName = data.first[2],
        lastName = data.first[3];
}
