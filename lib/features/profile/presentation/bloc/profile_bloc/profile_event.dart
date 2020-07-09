part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class FetchFirestoreUserProfile implements ProfileEvent {
  final BuildContext context;

  FetchFirestoreUserProfile({this.context});
}
