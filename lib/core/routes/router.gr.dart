// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:evoting/features/exitConfirm/exitConfirmScreen.dart';
import 'package:evoting/features/getStarted/getStartedScreen.dart';
import 'package:evoting/features/authentication/loginScreen.dart';
import 'package:evoting/features/authentication/registerScreen.dart';
import 'package:evoting/features/home_screen.dart';
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/service/contract_service.dart';
import 'package:evoting/core/routes/route_guards.dart';

abstract class Routes {
  static const exitConfirmScreen = '/';
  static const getStartedScreen = '/get-started-screen';
  static const loginScreen = '/login-screen';
  static const registerScreen = '/register-screen';
  static const homeScreen = '/home-screen';
  static const all = {
    exitConfirmScreen,
    getStartedScreen,
    loginScreen,
    registerScreen,
    homeScreen,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;
  @override
  Map<String, List<Type>> get guardedRoutes => {
        Routes.homeScreen: [AuthGuard],
      };
  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.exitConfirmScreen:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ExitConfirmScreen(),
          settings: settings,
        );
      case Routes.getStartedScreen:
        return MaterialPageRoute<dynamic>(
          builder: (context) => GetStartedScreen(),
          settings: settings,
        );
      case Routes.loginScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.registerScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              RegisterScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.homeScreen:
        if (hasInvalidArgs<HomeScreenArguments>(args)) {
          return misTypedArgsRoute<HomeScreenArguments>(args);
        }
        final typedArgs = args as HomeScreenArguments ?? HomeScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeScreen(
              addressService: typedArgs.addressService,
              configurationService: typedArgs.configurationService,
              contractService: typedArgs.contractService),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//HomeScreen arguments holder class
class HomeScreenArguments {
  final IAddressService addressService;
  final IConfigurationService configurationService;
  final IContractService contractService;
  HomeScreenArguments(
      {this.addressService, this.configurationService, this.contractService});
}
