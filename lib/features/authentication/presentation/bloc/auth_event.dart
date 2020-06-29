part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class RegisterUser implements AuthEvent {
  final String firstName;
  final String lastName;
  final String seedPhrase;
  final BuildContext context;

  RegisterUser({this.firstName, this.lastName, this.seedPhrase, this.context});

  @override
  List<Object> get props => [firstName, lastName, seedPhrase];

  @override
  bool get stringify => true;
}

class LoginUser implements AuthEvent {
  final String privateKey;
  final bool loginUsingSeed;
  final String seedPhrase;
  final BuildContext context;

  LoginUser(
      {this.privateKey, this.loginUsingSeed, this.seedPhrase, this.context});

  @override
  List<Object> get props => [privateKey, loginUsingSeed, context, seedPhrase];

  @override
  bool get stringify => true;
}
