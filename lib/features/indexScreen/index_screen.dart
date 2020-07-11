import 'dart:math';

import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/presentation/pages/election_screen.dart';
import 'package:evoting/features/home/presentation/pages/home_screen.dart';
import 'package:evoting/features/indexScreen/widget/navbar.dart';
import 'package:evoting/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:web3dart/credentials.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;
  bool isGuide = false;
  List<Widget> _viewsByIndex;
  String userId;
  @override
  void initState() {
    getLoggedInUser();
    super.initState();
  }

  void getLoggedInUser() async {
    EthereumAddress userKey = await AppConfig.loggedInUserKey;
    setState(() {
      userId = userKey.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", OMIcons.home, 110, Color(0xff01b87d)),
      NavBarItemData("Elections", OMIcons.assignment, 110, Color(0xff594ccf)),
      NavBarItemData("Profile", OMIcons.accountBox, 100, Color(0xffcf4c7a)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      ElectionScreen(),
      ProfileScreen(
        userId: userId,
      )
    ];

    var accentColor = _navBarItems[_selectedNavIndex].selectedColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
            child: Theme(
              data: ThemeData(accentColor: accentColor),
              child: contentView,
            ),
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
