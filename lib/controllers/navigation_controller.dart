import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/screens/authentication/login_screen.dart';
import 'package:smart_parking/screens/authentication/otp_screen.dart';
import 'package:smart_parking/screens/home_screen/main_page.dart';
import 'package:smart_parking/splash_screen.dart';
import 'package:smart_parking/utils/my_print.dart';

import '../screens/home_screen/home_screen_temp.dart';

class NavigationController {
  Route? onGeneratedRoutes(RouteSettings routeSettings) {
    MyPrint.printOnConsole("OnGeneratedRoutes Called for ${routeSettings.name} with arguments:${routeSettings.arguments}");

    Widget? widget;

    switch(routeSettings.name) {
      case SplashScreen.routeName : {
        widget = const SplashScreen();
        break;
      }
      case LoginScreen.routeName : {
        widget = const LoginScreen();
        break;
      }
      case OtpScreen.routeName : {
        String mobile = routeSettings.arguments?.toString() ?? "";
        if (mobile.isNotEmpty) {
          widget = OtpScreen(mobile: mobile,);
        }
        break;
      }
      case MainPage.routeName : {
        widget = const MainPage();
        // widget = const HomeScreenTemp();
        break;
      }
      default : {
        widget = const SplashScreen();
      }
    }

    if(widget != null)return MaterialPageRoute(builder: (_) => widget!);
  }
}