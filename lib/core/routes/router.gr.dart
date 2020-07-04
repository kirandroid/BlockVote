// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:evoting/features/exitConfirm/exitConfirmScreen.dart';
import 'package:evoting/features/getStarted/getStartedScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/loginScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/registerScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/register_complete_screen.dart';
import 'package:evoting/features/indexScreen/index_screen.dart';
import 'package:evoting/core/routes/route_guards.dart';
import 'package:evoting/features/election/presentation/pages/create_election_screen.dart';

abstract class Routes {
  static const exitConfirmScreen = '/';
  static const getStartedScreen = '/get-started-screen';
  static const loginScreen = '/login-screen';
  static const registerScreen = '/register-screen';
  static const registerCompleteScreen = '/register-complete-screen';
  static const indexScreen = '/index-screen';
  static const createElectionScreen = '/create-election-screen';
  static const all = {
    exitConfirmScreen,
    getStartedScreen,
    loginScreen,
    registerScreen,
    registerCompleteScreen,
    indexScreen,
    createElectionScreen,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;
  @override
  Map<String, List<Type>> get guardedRoutes => {
        Routes.indexScreen: [AuthGuard],
        Routes.createElectionScreen: [AuthGuard],
      };
  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
      case Routes.registerCompleteScreen:
        return MaterialPageRoute<dynamic>(
          builder: (context) => RegisterCompleteScreen(),
          settings: settings,
        );
      case Routes.indexScreen:
        return MaterialPageRoute<dynamic>(
          builder: (context) => IndexScreen(),
          settings: settings,
        );
      case Routes.createElectionScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CreateElectionScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
