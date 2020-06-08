import 'package:auto_route/auto_route.dart';
import 'package:evoting/core/routes/router.gr.dart';
import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/customButton.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  PageController _controller;

  @override
  void initState() {
    _controller = new TransformerPageController(
        itemCount: walkthroughItems.length, loop: false);
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);

    return Scaffold(
        backgroundColor: UIColors.primaryWhite,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.4,
                child: TransformerPageView(
                  pageController: _controller,
                  itemCount: walkthroughItems.length,
                  transformer: PageTransformerBuilder(
                      builder: (Widget child, TransformInfo info) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: <Widget>[
                          ParallaxContainer(
                            child: Text(
                              walkthroughItems[info.index]["title"],
                              textAlign: TextAlign.center,
                              style: StyleText.nunitoSemiBold.copyWith(
                                  fontSize: UISize.fontSize(25),
                                  letterSpacing: 2),
                            ),
                            position: info.position,
                            translationFactor: 200,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 25),
                            child: ParallaxContainer(
                              child: Text(
                                walkthroughItems[info.index]["subtitle"],
                                textAlign: TextAlign.center,
                                style: StyleText.ralewayMedium
                                    .copyWith(fontSize: UISize.fontSize(16)),
                              ),
                              position: info.position,
                              translationFactor: 100,
                            ),
                          ),
                          Expanded(
                              child: ParallaxContainer(
                            position: info.position,
                            translationFactor: 400,
                            child: Container(
                                height: ScreenUtil.screenHeight / 2,
                                padding: EdgeInsets.all(30),
                                width: ScreenUtil.screenHeight / 2,
                                child: Icon(Icons.wallpaper)
                                // Image.asset(
                                //     walkthroughItems[info.index]["image"])
                                ),
                          )),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              PageIndicator(
                layout: PageIndicatorLayout.SCALE,
                activeColor: UIColors.primaryTeal,
                color: Colors.grey,
                size: UISize.width(8.0),
                controller: _controller,
                space: UISize.width(5.0),
                count: walkthroughItems.length,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          flex: 1,
                          child: CustomButton(
                            buttonRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            title: "LOGIN",
                            onPressed: () {
                              ExtendedNavigator.of(context)
                                  .pushNamed(Routes.loginScreen);
                            },
                          )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UISize.width(5)),
                        child: Container(
                          width: 1,
                          height: UISize.width(50),
                          color: UIColors.lightGray,
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: CustomButton(
                            buttonRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            title: "REGISTER",
                            onPressed: () {
                              ExtendedNavigator.of(context)
                                  .pushNamed(Routes.registerScreen);
                            },
                          ))
                    ],
                  )),
            ],
          ),
        ));
  }

  final List walkthroughItems = [
    {
      "title": "BLOCKVOTE",
      "subtitle":
          "A Blockchain based voting application that allows you to host or vote a poll.",
      "image": "lib/assets/images/walkthrough2.png"
    },
    {
      "title": "PROTECT YOUR PRIVACY",
      "subtitle":
          "Nobody can track or alter who you vote. Privacy is guranteed!",
      "image": "lib/assets/images/walkthrough3.png"
    },
    {
      "title": "REALTIME VOTING RESULT",
      "subtitle":
          "Get a realtime view of voting result in an interactive chart.",
      "image": "lib/assets/images/walkthrough4.png"
    },
  ];
}
