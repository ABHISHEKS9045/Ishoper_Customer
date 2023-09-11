import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources2.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/auth_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/splash/widget/splash_painter.dart';

import '../../../provider/profile_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String TAG = "_SplashScreenState";
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  // checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   debugPrint("$TAG login status =========> ${prefs.getBool('isLoggedIn')}");
  //
  //   var loginStatus = prefs.getBool('isLoggedIn');
  //   if (loginStatus == true) {
  //     Get.offAll(() => AuthScreen());
  //   } else if (loginStatus == false) {
  //     Get.offAll(
  //       () => DashBoardScreen(),
  //     );
  //   } else {
  //     Get.offAll(() => AuthScreen());
  //   }
  // }

  @override
  void initState() {
    // checkLoginStatus();
    debugPrint("$TAG login status =========> ${Provider.of<AuthProvider>(context, listen: false).isLoggedIn()}");
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Timer(
      Duration(seconds: 2),
          () => _route(),
    );
    // _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false).initSharedPrefData();
        Timer(Duration(seconds: 1), () {
                  if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .updateToken(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => DashboardScreen()));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => AuthScreen()));
                  }
                });
      }
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   NetworkInfo.checkConnectivity(context);
  //   Provider.of<SplashProvider>(context, listen: false)
  //       .initConfig(context)
  //       .then((bool isSuccess) {
  //     if (isSuccess) {
  //       Timer(Duration(seconds: 1), () {
  //         if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
  //           Provider.of<AuthProvider>(context, listen: false)
  //               .updateToken(context);
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //               builder: (BuildContext context) => DashboardScreen()));
  //         } else {
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //               builder: (BuildContext context) => AuthScreen()));
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.black
              : ColorResources.getPrimary(context),
          child: CustomPaint(
            painter: SplashPainter(),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Images.logo, height: 120.0, fit: BoxFit.scaleDown, width: 200.0, color: Theme.of(context).highlightColor
              // Image.asset("assets/image/logo.png"),
              Text(
                AppConstants.APP_NAME,
                style: titilliumBold.copyWith(
                    fontSize:    20.0,
                    color: Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.white
                        : ColorResources.WHITE),
              ),
              SizedBox(height: 10),
              // Text(
              //   "Seller",
              //   style: TextStyle(
              //     //  Provider.of<ThemeProvider>(context).darkTheme   ? Colors.white : ColorResources.WHITE
                      
              //          fontSize: 16.0,
              //       color:Colors.white),
              // ),
              // getTranslated('vendor', context), style: titilliumBold.copyWith(

              // ),
            ],
          ),
        ),
      ],
    ));
  }
}
