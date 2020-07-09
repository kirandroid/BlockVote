part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileCompleted extends ProfileState {
  final FirestoreUserResponse firestoreUserResponse;

  ProfileCompleted({this.firestoreUserResponse});
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError({this.errorMessage});
}
