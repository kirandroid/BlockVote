import 'package:evoting/features/election/presentation/bloc/candidate_info_bloc/candidate_info_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/create_election_bloc/create_election_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:evoting/features/election/presentation/bloc/election_list_bloc/election_list_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  _blocRegister();
}

void _blocRegister() {
  sl.registerLazySingleton(() => ElectionDetailBloc());
  sl.registerLazySingleton(() => ElectionListBloc());
  sl.registerLazySingleton(() => CreateElectionBloc());
  sl.registerLazySingleton(() => CandidateInfoBloc());
}
