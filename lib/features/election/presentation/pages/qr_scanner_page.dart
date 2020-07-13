import 'dart:ui';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/di.dart';
import 'package:evoting/features/election/presentation/bloc/scan_qr_bloc/scan_qr_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserQRScannerPage extends StatefulWidget {
  const UserQRScannerPage({
    Key key,
  }) : super(key: key);

  @override
  _UserQRScannerPageState createState() => _UserQRScannerPageState();
}

class _UserQRScannerPageState extends State<UserQRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  final ScanQrBloc scanQRBloc = sl<ScanQrBloc>();

  void scanQR({String qrText}) async {
    scanQRBloc.add(ScanQR(qrCode: qrText, context: context));
  }

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
      backgroundColor: UIColors.primaryWhite,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                //
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: UIColors.primaryWhite,
                    borderRadius: UISize.width(10.0),
                    borderLength: UISize.width(100.0),
                    borderWidth: UISize.width(10.0),
                    cutOutSize: ScreenUtil.screenWidthDp - UISize.width(200.0),
                  ),
                ),

                //
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: UISize.width(20.0),
                            right: UISize.width(20.0),
                            bottom: UISize.height(30.0),
                            top: MediaQuery.of(context).padding.top +
                                UISize.height(30.0),
                          ),
                          color: UIColors.blur.withOpacity(0.2),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: UISize.width(32.0),
                                  width: UISize.width(32.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        UISize.width(16.0)),
                                    color: UIColors.primaryWhite,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: UIColors.mediumGray,
                                    size: UISize.fontSize(18.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "QR SCANNER FOR CHECK-IN",
                                  textAlign: TextAlign.center,
                                  style: StyleText.nunitoBold.copyWith(
                                    color: UIColors.primaryWhite,
                                    fontSize: UISize.fontSize(14.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: UISize.width(32.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: UISize.height(ScreenUtil.screenHeightDp * 0.3),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Place QR code within the rectangle above.",
                      style: StyleText.ralewayMedium.copyWith(
                        color: UIColors.primaryWhite,
                        fontSize: UISize.fontSize(14.0),
                      ),
                    ),
                  ),
                ),

                //
              ],
            ),
          ),
          BlocBuilder<ScanQrBloc, ScanQrState>(
            bloc: this.scanQRBloc,
            builder: (BuildContext context, ScanQrState state) {
              if (state is LoadingScanQrState) {
                return Container(
                  color: Colors.white.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              } else if (state is NoDataScanQrState ||
                  state is ErrorScanQrState) {
                controller.resumeCamera();
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      scanQR(qrText: scanData);

      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    scanQRBloc.close();
    super.dispose();
  }
}
