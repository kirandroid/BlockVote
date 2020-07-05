import 'package:evoting/features/election/presentation/bloc/election_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  _blocRegister();
}

void _blocRegister() {
  sl.registerLazySingleton(() => ElectionBloc());
}
