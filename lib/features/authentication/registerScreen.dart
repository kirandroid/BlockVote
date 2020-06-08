import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/features/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String mnemonic = '';
  ConfigurationService configurationService;
  AddressService addressService;
  @override
  void initState() {
    configurationService = ConfigurationService();
    addressService = AddressService(configurationService);
    mnemonic = addressService.generateMnemonic();
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
                  await addressService.setupFromMnemonic(mnemonic);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            addressService: addressService,
                            configurationService: configurationService,
                          )));
                })
          ],
        ),
      ),
    );
  }
}
