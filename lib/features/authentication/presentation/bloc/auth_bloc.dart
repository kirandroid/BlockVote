import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:web3dart/contracts.dart';
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
      final ConfigurationService configurationService = ConfigurationService();
      final AddressService addressService =
          AddressService(configurationService);
      final String privateKey = addressService.getPrivateKey(event.seedPhrase);
      final EthereumAddress publicKey = await addressService.getPublicAddress(
          "AD4B73FFC7D73417AA67B7AB8327F5BD6DE92C11E9F0C5FD8BE631C270282493");

      final credentials = await AppConfig().ethClient().credentialsFromPrivateKey(
          "AD4B73FFC7D73417AA67B7AB8327F5BD6DE92C11E9F0C5FD8BE631C270282493");

      yield AuthLoading();
      // try {
      //   Response response =
      //       await Dio().get('https://faucet.ropsten.be/donate/$publicKey');
      //   print(response);
      // } catch (e) {
      //   print(e);
      // }
      AppConfig.contractAddress.then((contract) async {
        final registerFunction = contract.function('registerUser');
        await AppConfig()
            .ethClient()
            .sendTransaction(
                credentials,
                Transaction.callContract(
                    contract: contract,
                    function: registerFunction,
                    parameters: [publicKey, event.firstName, event.lastName]))
            .then((value) => print(value));
      });
    }
  }
}
