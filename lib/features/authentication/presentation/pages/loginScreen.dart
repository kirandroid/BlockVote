import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/customButton.dart';
import 'package:evoting/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:evoting/features/authentication/presentation/widgets/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
// private: aa817d42c4355d1a7fb29456a38c718b6305884099ab544660288e1b542d8ce9
// address: 0xc5347ee4386b5b1ebf59488c8028b56ba65163ac

//benefit stand jar trim oak also rail lazy calm disorder bubble success

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController seedPhraseController = TextEditingController();
  String _loginType = "seed";
  bool isLoading = false;

  AuthBloc _authBloc = AuthBloc();

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: this._authBloc,
        listener: (BuildContext context, AuthState state) {
          if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Scaffold(
            backgroundColor: UIColors.primaryWhite,
            appBar: AppBar(
              backgroundColor: UIColors.primaryWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: UIColors.primaryLightBlack,
                  ),
                  onPressed: () {
                    ExtendedNavigator.of(context).pop();
                  }),
              title: Text(
                "Login to your account",
                style: StyleText.nunitoMedium.copyWith(
                    fontSize: UISize.fontSize(18),
                    color: UIColors.primaryLightBlack),
              ),
            ),
            body: SafeArea(
                child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Padding(
                padding: EdgeInsets.all(UISize.width(20)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: UISize.width(16)),
                      child: ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20,
                          activeBgColor: Colors.green,
                          activeTextColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveTextColor: Colors.white,
                          labels: ['Seed Phrase', 'Private Key'],
                          activeColors: [
                            UIColors.primaryDarkTeal,
                            UIColors.primaryDarkTeal
                          ],
                          onToggle: (index) {
                            seedPhraseController.clear();
                            setState(() {
                              _loginType = index == 0 ? "seed" : "private";
                            });
                          }),
                    ),
                    TextField(
                      controller: seedPhraseController,
                      autocorrect: false,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      textAlignVertical: TextAlignVertical.center,
                      style: StyleText.nunitoMedium.copyWith(
                          fontSize: UISize.fontSize(13),
                          color: UIColors.darkGray),
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
                        hintText:
                            "Enter your ${_loginType == 'seed' ? 'seed phrase' : 'private key'}",
                        hintStyle: StyleText.nunitoMedium.copyWith(
                            fontSize: UISize.fontSize(14),
                            color: UIColors.greyText),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(UISize.width(23)),
                            borderSide: BorderSide(style: BorderStyle.none)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(UISize.width(23)),
                            borderSide: BorderSide(style: BorderStyle.none)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UISize.width(16)),
                      child: CustomButton(
                        buttonColor: UIColors.primaryDarkTeal,
                        title: "LOGIN",
                        isLoading: isLoading,
                        onPressed: () {
                          _authBloc.add(LoginUser(
                              loginUsingSeed:
                                  _loginType == 'seed' ? true : false,
                              privateKey: seedPhraseController.text,
                              seedPhrase: seedPhraseController.text,
                              context: context));
                        },
                      ),
                    )
                  ],
                ),
              ),
            )),
          );
        });
  }
}
