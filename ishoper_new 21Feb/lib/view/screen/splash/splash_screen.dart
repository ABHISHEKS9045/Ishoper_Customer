import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

// ignore: prefer_relative_imports
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';

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
          if (Provider.of<SplashProvider>(context, listen: false).configModel.maintenanceMode) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => MaintenanceScreen(),
              ),
            );
          } else {
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken(context);
              Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => DashBoardScreen(),
                ),
              );
            } else {
              if (Provider.of<SplashProvider>(context, listen: false).showIntro()) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => OnBoardingScreen(
                      indicatorColor: ColorResources.GREY,
                      selectedIndicatorColor: color.colortheme,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AuthScreen(),
                  ),
                );
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
                  child: Image.asset(
                    "assets/images/splashscreen.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : NoInternetOrDataScreen(isNoInternet: true, child: SplashScreen()),
    );
  }
}

class SplashScreenFirst extends StatefulWidget {
  const SplashScreenFirst({Key key}) : super(key: key);

  @override
  State<SplashScreenFirst> createState() => _SplashScreenFirstState();
}

class _SplashScreenFirstState extends State<SplashScreenFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: color.colortheme,
      // decoration: BoxDecoration(
      //     color: color.colortheme,
      //     image: DecorationImage(
      //       image: ExactAssetImage(
      //         "assets/images/logo.png",
      //       ),
      //     )),
      child: Center(
        child: Image.asset(
          "assets/images/logo.png",
          color: color.colorWhite,
        ),
      ),
    ));
  }
}

////////////////////////
class SecondSplash extends StatelessWidget {
  const SecondSplash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage("assets/images/image2splash.png"), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 450.0, right: 50.0),
              child: Image.asset("assets/images/makeyour.png"),
            ),
            color.sizedboxheight(10.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 15.0,
                right: 130,
              ),
              child: letsStart(context),
            )
          ],
        ),
      ),
    );
  }
}

ColorResources color = ColorResources();

Widget letsStart(context) {
  return ElevatedButton(
    style: TextButton.styleFrom(
      backgroundColor: color.colorlightwhite,
      minimumSize: Size(double.infinity, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: () async {
      Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SecondSplash(),
          ),
        ),
      );
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => AuthScreen(),
        ),
      );
    },
    child: Row(
      children: [
        color.sizedboxwidth(20.0),
        Image.asset(
          "assets/images/letsstart.png",
        ),
        color.sizedboxwidth(10.0),
        Image.asset(
          "assets/images/arrowicon.png",
        ),
      ],
    ),
  );
}
