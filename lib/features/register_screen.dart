import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/features/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final IAddressService _addressService;
  final ConfigurationService configurationService;
  RegisterScreen(this._addressService, this.configurationService);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String mnemonic = '';
  @override
  void initState() {
    mnemonic = widget._addressService.generateMnemonic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              mnemonic,
              textAlign: TextAlign.center,
            ),
            RaisedButton(
                child: Text("Create Account"),
                onPressed: () async {
                  await widget._addressService.setupFromMnemonic(mnemonic);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            addressService: widget._addressService,
                            configurationService: widget.configurationService,
                          )));
                })
          ],
        ),
      ),
    );
  }
}
