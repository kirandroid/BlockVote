part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostEvent {}

class CreatePost implements CreatePostEvent {
  final File postImage;
  final String postText;
  final BuildContext context;

  CreatePost({this.postImage, this.postText, this.context});
}
