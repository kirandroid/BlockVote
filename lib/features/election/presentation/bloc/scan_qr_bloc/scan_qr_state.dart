part of 'scan_qr_bloc.dart';

abstract class ScanQrState {
  const ScanQrState();
}

class ScanQrInitial extends ScanQrState {}

class LoadingScanQrState extends ScanQrState {}

class CompletedScanQrState extends ScanQrState {}

class NoDataScanQrState extends ScanQrState {}

class ErrorScanQrState extends ScanQrState {}
