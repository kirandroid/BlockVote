import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/service/address_service.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/customButton.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:evoting/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String mnemonic = '';
  ConfigurationService configurationService;
  AddressService addressService;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  AuthBloc _authBloc = AuthBloc();

  @override
  void initState() {
    configurationService = ConfigurationService();
    addressService = AddressService(configurationService);
    mnemonic = addressService.generateMnemonic();
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: UIColors.primaryWhite,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: UIColors.darkGray,
            ),
            onPressed: () {
              ExtendedNavigator.of(context).pop();
            }),
        title: Text(
          "Register an account",
          style: StyleText.nunitoMedium.copyWith(
              fontSize: UISize.fontSize(18), color: UIColors.primaryLightBlack),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UISize.width(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: firstNameController,
              autocorrect: false,
              autofocus: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              style: StyleText.nunitoMedium.copyWith(
                  fontSize: UISize.fontSize(13), color: UIColors.darkGray),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: UIColors.primaryDarkTeal,
                ),
                isDense: true,
                filled: true,
                fillColor: UIColors.lightGray,
                contentPadding: EdgeInsets.only(
                    top: UISize.width(14),
                    bottom: UISize.width(14),
                    left: UISize.width(15)),
                hintText: "First Name",
                hintStyle: StyleText.nunitoMedium.copyWith(
                    fontSize: UISize.fontSize(14), color: UIColors.greyText),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UISize.width(23)),
                    borderSide: BorderSide(style: BorderStyle.none)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UISize.width(23)),
                    borderSide: BorderSide(style: BorderStyle.none)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: lastNameController,
              autocorrect: false,
              autofocus: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              style: StyleText.nunitoMedium.copyWith(
                  fontSize: UISize.fontSize(13), color: UIColors.darkGray),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: UIColors.primaryDarkTeal,
                ),
                isDense: true,
                filled: true,
                fillColor: UIColors.lightGray,
                contentPadding: EdgeInsets.only(
                    top: UISize.width(14),
                    bottom: UISize.width(14),
                    left: UISize.width(15)),
                hintText: "Last Name",
                hintStyle: StyleText.nunitoMedium.copyWith(
                    fontSize: UISize.fontSize(14), color: UIColors.greyText),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UISize.width(23)),
                    borderSide: BorderSide(style: BorderStyle.none)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UISize.width(23)),
                    borderSide: BorderSide(style: BorderStyle.none)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: UISize.width(14)),
              child: Text(
                "This is your seed phrase which can be used to login to your account, so please keep it safe as it cannot be recovered by any means.",
                textAlign: TextAlign.center,
                style: StyleText.ralewaySemiBold.copyWith(
                    fontSize: UISize.fontSize(14), color: UIColors.darkGray),
              ),
            ),
            Container(
              padding: EdgeInsets.all(UISize.width(12)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: UIColors.primaryDarkTeal, width: 2)),
              child: Text(
                mnemonic,
                textAlign: TextAlign.center,
                style: StyleText.ralewayMedium.copyWith(
                    fontSize: UISize.fontSize(14), color: UIColors.darkGray),
              ),
            ),
            SizedBox(
              height: UISize.width(16),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    buttonColor: UIColors.primaryPink,
                    buttonRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    title: "Copy",
                    verticalPadding: UISize.width(16),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: mnemonic));
                      Toast().showToast(
                          context: context, message: "Menomic Copied!");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: UISize.width(5)),
                  child: Container(
                    width: 1,
                    height: UISize.width(50),
                    color: UIColors.lightGray,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    buttonColor: UIColors.primaryDarkTeal,
                    buttonRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    title: "Register",
                    verticalPadding: UISize.width(16),
                    onPressed: () {
                      _authBloc.add(RegisterUser(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          seedPhrase: mnemonic,
                          context: context));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
