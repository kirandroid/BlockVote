import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/features/authentication/domain/entities/user_response.dart';
import 'package:flutter/widgets.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is RegisterUser) {
      final EthereumAddress publicKey =
          await AppConfig.publicKeyFromSeed(seedPhrase: event.seedPhrase);

      yield AuthLoading();

      final bool response = await AppConfig.runTransaction(
          functionName: 'registerUser',
          parameter: [publicKey, event.firstName, event.lastName]);

      if (response) {
        yield AuthCompleted();
        ExtendedNavigator.of(event.context)
            .pushReplacementNamed(Routes.registerCompleteScreen);
      } else {
        yield AuthError();
        Toast().showToast(
            context: event.context,
            message: "Error while registering!",
            title: "Error!");
      }
    } else if (event is LoginUser) {
      yield AuthLoading();
      if (event.loginUsingSeed) {
        final EthereumAddress publicKey =
            await AppConfig.publicKeyFromSeed(seedPhrase: event.seedPhrase);

        AppConfig.contract.then((contract) async {
          final getUserFunction = contract.function('getUser');
          UserResponse userResponse = UserResponse.fromMap(await AppConfig()
              .ethClient()
              .call(
                  contract: contract,
                  function: getUserFunction,
                  params: [publicKey]));
          if (userResponse.userId.toString() ==
              "0x0000000000000000000000000000000000000000") {
            // yield AuthError();
            Toast().showToast(
                context: event.context,
                message: "Error while login!",
                title: "Error!");
          } else {
            // yield AuthCompleted();
            // ExtendedNavigator.of(event.context)
            //     .pushReplacementNamed(Routes.registerCompleteScreen);
            Toast().showToast(
                context: event.context,
                message:
                    "FirstName: ${userResponse.firstName} | LastName: ${userResponse.lastName}",
                title: "Success!");
          }
        });
      } else {}
    }
  }
}
