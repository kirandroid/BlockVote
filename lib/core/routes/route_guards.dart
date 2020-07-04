import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/configuration_service.dart';

class AuthGuard extends RouteGuard {
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    final ConfigurationService configurationService = ConfigurationService();
    final bool isLoggedIn = await configurationService.didSetupWallet();
    if (isLoggedIn) {
      return true;
    }
    navigator.pushReplacementNamed(Routes.getStartedScreen);
    return false;
  }
}
