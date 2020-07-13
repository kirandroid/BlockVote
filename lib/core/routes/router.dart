import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:evoting/core/routes/route_guards.dart';
import 'package:evoting/features/authentication/presentation/pages/loginScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/registerScreen.dart';
import 'package:evoting/features/authentication/presentation/pages/register_complete_screen.dart';
import 'package:evoting/features/election/presentation/pages/candidate_info_screen.dart';
import 'package:evoting/features/election/presentation/pages/create_election_screen.dart';
import 'package:evoting/features/election/presentation/pages/election_detail_screen.dart';
import 'package:evoting/features/election/presentation/pages/qr_scanner_page.dart';
import 'package:evoting/features/exitConfirm/exitConfirmScreen.dart';
import 'package:evoting/features/getStarted/getStartedScreen.dart';
import 'package:evoting/features/home/presentation/pages/create_post_screen.dart';
import 'package:evoting/features/home/presentation/pages/post_detail_screen.dart';
import 'package:evoting/features/indexScreen/index_screen.dart';
import 'package:evoting/features/profile/presentation/pages/profile_screen.dart';

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

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  CreateElectionScreen createElectionScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  ElectionDetailScreen electionDetailScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  CandidateInfoScreen candidateInfoScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  CreatePostScreen createPostScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  PostDetailScreen postDetailScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  ProfileScreen profileScreen;

  @GuardedBy([AuthGuard])
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  )
  UserQRScannerPage userQRScannerPage;
}
