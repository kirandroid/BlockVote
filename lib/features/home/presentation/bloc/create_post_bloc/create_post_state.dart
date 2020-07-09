part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostState {}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostCompleted extends CreatePostState {}

class CreatePostError extends CreatePostState {}
