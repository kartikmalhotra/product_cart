import 'dart:async';

import 'package:bwys/bwys_app.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/login/screens/signin.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Apply a Timer for 3 seconds for Splash Screen
    _displaySplashScreen();
  }

  void _displaySplashScreen() {
    Timer(Duration(seconds: 2), () {
      if (Application.firebaseService!.checkUser()) {
        Navigator.popAndPushNamed(context, AppRoutes.appScreen);
      } else {
        Navigator.popAndPushNamed(context, AppRoutes.root);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SetAppScreenConfiguration.init(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              "Product Cart",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
            AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
            AppCircularProgressLoader(
              strokeColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
