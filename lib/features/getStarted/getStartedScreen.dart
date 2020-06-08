import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("GO"),
            onPressed: () {
              ExtendedNavigator.of(context).pushNamed(Routes.homeScreen);
            },
          )
        ],
      ),
    );
  }
}
