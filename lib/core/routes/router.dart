import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:evoting/core/routes/route_guards.dart';
import 'package:evoting/features/authentication/presentation/pages/loginScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/registerScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/register_complete_screen.dart';
import 'package:evoting/features/exitConfirm/exitConfirmScreen.dart';
import 'package:evoting/features/getStarted/getStartedScreen.dart';
import 'package:evoting/features/home_screen.dart';
import 'package:evoting/features/indexScreen/index_screen.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  ExitConfirmScreen exitConfirmScreen;
  GetStartedScreen getStartedScreen;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  LoginScreen loginScreen;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  RegisterScreen registerScreen;

  RegisterCompleteScreen registerCompleteScreen;

  @GuardedBy([AuthGuard])
  IndexScreen indexScreen;
  HomeScreen homeScreen;
}
