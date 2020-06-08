import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';

class AuthGuard extends RouteGuard {
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    if (isLoggedIn) {
      return true;
    }
    navigator.pushReplacementNamed(Routes.getStartedScreen);
    return false;
  }
}

var isLoggedIn = true;
