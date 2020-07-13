part of 'scan_qr_bloc.dart';

abstract class ScanQrEvent extends Equatable {
  const ScanQrEvent();
}

class ScanQR extends ScanQrEvent {
  final String qrCode;
  final BuildContext context;

  ScanQR({@required this.qrCode, this.context});

  @override
  List<Object> get props => null;
}
