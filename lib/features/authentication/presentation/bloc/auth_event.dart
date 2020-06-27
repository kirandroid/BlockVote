part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class RegisterUser implements AuthEvent {
  final String firstName;
  final String lastName;
  final String seedPhrase;

  RegisterUser({this.firstName, this.lastName, this.seedPhrase});

  @override
  List<Object> get props => [firstName, lastName, seedPhrase];

  @override
  bool get stringify => true;
}
