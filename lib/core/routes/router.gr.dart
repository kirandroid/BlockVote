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
import 'package:evoting/features/election/presentation/pages/election_detail_screen.dart';
import 'package:evoting/features/election/presentation/pages/candidate_info_screen.dart';
import 'package:evoting/features/home/presentation/pages/create_post_screen.dart';
import 'package:evoting/features/home/presentation/pages/post_detail_screen.dart';
import 'package:evoting/features/profile/presentation/pages/profile_screen.dart';
import 'package:evoting/features/election/presentation/pages/qr_scanner_page.dart';

abstract class Routes {
  static const exitConfirmScreen = '/';
  static const getStartedScreen = '/get-started-screen';
  static const loginScreen = '/login-screen';
  static const registerScreen = '/register-screen';
  static const registerCompleteScreen = '/register-complete-screen';
  static const indexScreen = '/index-screen';
  static const createElectionScreen = '/create-election-screen';
  static const electionDetailScreen = '/election-detail-screen';
  static const candidateInfoScreen = '/candidate-info-screen';
  static const createPostScreen = '/create-post-screen';
  static const postDetailScreen = '/post-detail-screen';
  static const profileScreen = '/profile-screen';
  static const userQRScannerPage = '/user-qr-scanner-page';
  static const all = {
    exitConfirmScreen,
    getStartedScreen,
    loginScreen,
    registerScreen,
    registerCompleteScreen,
    indexScreen,
    createElectionScreen,
    electionDetailScreen,
    candidateInfoScreen,
    createPostScreen,
    postDetailScreen,
    profileScreen,
    userQRScannerPage,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;
  @override
  Map<String, List<Type>> get guardedRoutes => {
        Routes.indexScreen: [AuthGuard],
        Routes.createElectionScreen: [AuthGuard],
        Routes.electionDetailScreen: [AuthGuard],
        Routes.candidateInfoScreen: [AuthGuard],
        Routes.createPostScreen: [AuthGuard],
        Routes.postDetailScreen: [AuthGuard],
        Routes.profileScreen: [AuthGuard],
        Routes.userQRScannerPage: [AuthGuard],
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
      case Routes.electionDetailScreen:
        if (hasInvalidArgs<ElectionDetailScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ElectionDetailScreenArguments>(args);
        }
        final typedArgs = args as ElectionDetailScreenArguments;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ElectionDetailScreen(electionId: typedArgs.electionId),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.candidateInfoScreen:
        if (hasInvalidArgs<CandidateInfoScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<CandidateInfoScreenArguments>(args);
        }
        final typedArgs = args as CandidateInfoScreenArguments;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CandidateInfoScreen(candidateId: typedArgs.candidateId),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.createPostScreen:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CreatePostScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.postDetailScreen:
        if (hasInvalidArgs<PostDetailScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<PostDetailScreenArguments>(args);
        }
        final typedArgs = args as PostDetailScreenArguments;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PostDetailScreen(
                  postId: typedArgs.postId,
                  loggedInUser: typedArgs.loggedInUser),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.profileScreen:
        if (hasInvalidArgs<ProfileScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<ProfileScreenArguments>(args);
        }
        final typedArgs = args as ProfileScreenArguments;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfileScreen(userId: typedArgs.userId),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Routes.userQRScannerPage:
        if (hasInvalidArgs<UserQRScannerPageArguments>(args)) {
          return misTypedArgsRoute<UserQRScannerPageArguments>(args);
        }
        final typedArgs =
            args as UserQRScannerPageArguments ?? UserQRScannerPageArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserQRScannerPage(key: typedArgs.key),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//ElectionDetailScreen arguments holder class
class ElectionDetailScreenArguments {
  final String electionId;
  ElectionDetailScreenArguments({@required this.electionId});
}

//CandidateInfoScreen arguments holder class
class CandidateInfoScreenArguments {
  final String candidateId;
  CandidateInfoScreenArguments({@required this.candidateId});
}

//PostDetailScreen arguments holder class
class PostDetailScreenArguments {
  final String postId;
  final String loggedInUser;
  PostDetailScreenArguments(
      {@required this.postId, @required this.loggedInUser});
}

//ProfileScreen arguments holder class
class ProfileScreenArguments {
  final String userId;
  ProfileScreenArguments({@required this.userId});
}

//UserQRScannerPage arguments holder class
class UserQRScannerPageArguments {
  final Key key;
  UserQRScannerPageArguments({this.key});
}
