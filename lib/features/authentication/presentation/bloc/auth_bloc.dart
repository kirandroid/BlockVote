import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/utils/strings.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/features/authentication/domain/entities/user_response.dart';
import 'package:evoting/features/profile/domain/firestore_user_response.dart';
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
          functionName: 'registerUser', parameter: [publicKey]);

      if (response) {
        try {
          await Firestore.instance
              .collection("users")
              .document(publicKey.toString())
              .setData(FirestoreUserResponse(
                  firstName: event.firstName,
                  gender: event.gender,
                  id: publicKey.toString(),
                  lastName: event.lastName,
                  profilePicture: UIStrings.defaultProfilePicURL,
                  myElections: [],
                  participatedElections: []).toMap());

          yield AuthCompleted();
          ExtendedNavigator.of(event.context)
              .pushReplacementNamed(Routes.registerCompleteScreen);
        } catch (e) {
          print(e);
        }
      } else {
        yield AuthError();
        Toast().showToast(
            context: event.context,
            message: "Error while registering!",
            title: "Error!");
      }
    } else if (event is LoginUser) {
      yield AuthLoading();

      final DeployedContract contract =
          await AppConfig.contract.then((value) => value);
      final ConfigurationService configurationService = ConfigurationService();
      final AddressService addressService =
          AddressService(configurationService);

      if (event.loginUsingSeed) {
        final EthereumAddress publicKey =
            await AppConfig.publicKeyFromSeed(seedPhrase: event.seedPhrase);
        AuthState stateFromLogin = await _checkLoginState(
            context: event.context, publicKey: publicKey, contract: contract);
        if (stateFromLogin is AuthCompleted) {
          await addressService.setupFromMnemonic(event.seedPhrase);
          yield stateFromLogin;
          ExtendedNavigator.of(event.context)
              .pushReplacementNamed(Routes.indexScreen);
        } else {
          yield stateFromLogin;
        }
      } else {
        final EthereumAddress publicKey =
            await AppConfig.publicKeyFromPrivate(privateKey: event.privateKey);
        AuthState stateFromLogin = await _checkLoginState(
            context: event.context, publicKey: publicKey, contract: contract);
        if (stateFromLogin is AuthCompleted) {
          await addressService.setupFromPrivateKey(event.privateKey);
          yield stateFromLogin;
          ExtendedNavigator.of(event.context)
              .pushReplacementNamed(Routes.indexScreen);
        } else {
          yield stateFromLogin;
        }
      }
    }
  }

  Future<AuthState> _checkLoginState(
      {EthereumAddress publicKey,
      BuildContext context,
      DeployedContract contract}) async {
    final getUserFunction = contract.function('getUser');
    UserResponse userResponse = UserResponse.fromMap(await AppConfig()
        .ethClient()
        .call(
            contract: contract,
            function: getUserFunction,
            params: [publicKey]));
    if (userResponse.userId.toString() ==
        "0x0000000000000000000000000000000000000000") {
      Toast().showToast(
          context: context, message: "Error while login!", title: "Error!");
      return AuthError();
    } else {
      print("Success");
      return AuthCompleted();
    }
  }
}
