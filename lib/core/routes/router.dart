import 'package:auto_route/auto_route_annotations.dart';
import 'package:evoting/core/routes/route_guards.dart';
import 'package:evoting/features/exitConfirm/exitConfirmScreen.dart';
import 'package:evoting/features/getStarted/getStartedScreen.dart';
import 'package:evoting/features/home_screen.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  ExitConfirmScreen exitConfirmScreen;
  GetStartedScreen getStartedScreen;

  @GuardedBy([AuthGuard])
  HomeScreen homeScreen;
}
