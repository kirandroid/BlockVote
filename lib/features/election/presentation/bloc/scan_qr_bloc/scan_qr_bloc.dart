import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

part 'scan_qr_event.dart';
part 'scan_qr_state.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  @override
  ScanQrState get initialState => ScanQrInitial();

  @override
  Stream<ScanQrState> mapEventToState(
    ScanQrEvent event,
  ) async* {
    if (event is ScanQR) {
      yield LoadingScanQrState();
      ScanQrState stateFromRemote =
          await _mapScanQrToState(context: event.context, qrcode: event.qrCode);

      if (stateFromRemote is CompletedScanQrState ||
          stateFromRemote is NoDataScanQrState ||
          stateFromRemote is ErrorScanQrState) {
        yield stateFromRemote;
      } else {
        return;
      }
    }
  }
}

Future<ScanQrState> _mapScanQrToState(
    {String qrcode, BuildContext context}) async {
  final DeployedContract contract =
      await AppConfig.contract.then((value) => value);
  final getElectionIdList = contract.function('getAllElectionId');
  await AppConfig().ethClient().call(
      contract: contract,
      function: getElectionIdList,
      params: []).then((electionIdList) async {
    if (electionIdList.first.contains(qrcode)) {
      ExtendedNavigator.of(context).pushReplacementNamed(
          Routes.electionDetailScreen,
          arguments: ElectionDetailScreenArguments(electionId: qrcode));
      return CompletedScanQrState();
    } else {
      Toast().showToast(
          title: "Error",
          message: "Could not find the election.",
          context: context);
      return ErrorScanQrState();
    }
  });
  return ErrorScanQrState();
}
