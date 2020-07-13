import 'package:evoting/features/election/presentation/bloc/candidate_info_bloc/candidate_info_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/create_election_bloc/create_election_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/scan_qr_bloc/scan_qr_bloc.dart';
import 'package:evoting/features/home/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:evoting/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  _blocRegister();
}

void _blocRegister() {
  sl.registerLazySingleton(() => ElectionDetailBloc());
  sl.registerLazySingleton(() => ElectionListBloc());
  sl.registerFactory(() => CreateElectionBloc());
  sl.registerLazySingleton(() => CandidateInfoBloc());
  sl.registerFactory(() => CreatePostBloc());
  sl.registerFactory(() => ProfileBloc());
  sl.registerFactory(() => ScanQrBloc());
}
