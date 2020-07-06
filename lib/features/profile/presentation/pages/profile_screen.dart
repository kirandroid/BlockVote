import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/service/configuration_service.dart';
import 'package:evoting/core/widgets/toast.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            final ConfigurationService configurationService =
                ConfigurationService();
            final bool dbCleared = await configurationService.clearDB();
            dbCleared
                ? ExtendedNavigator.of(context)
                    .pushReplacementNamed(Routes.getStartedScreen)
                : Toast().showToast(
                    context: context,
                    title: "Error",
                    message: "Error when logging out!");
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
