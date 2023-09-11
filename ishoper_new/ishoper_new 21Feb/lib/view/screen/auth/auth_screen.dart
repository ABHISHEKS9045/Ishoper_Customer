// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_in_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatelessWidget {
  final int initialPage;

  AuthScreen({this.initialPage = 0});

  ColorResources color = ColorResources();

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isRemember;
    PageController _pageController = PageController(initialPage: initialPage);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color.colortheme,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(270.0),
        child: Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                height: 100,
                fit: BoxFit.cover,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       color.sizedboxwidth(230.0),
              //       Image.asset(
              //         "assets/images/app_logo.png",
              //         height: 3.h,
              //         width: 30.w,
              //         fit: BoxFit.cover,
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 40.0, right: 40, left: 110),
              //   child: Text("Sign In", textAlign: TextAlign.center, style: TextStyle(fontSize: 35.0, color: color.colorlightwhite)),
              // ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
          child: Container(
            color: color.colorWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.topSpace),
                // Image.asset(Images.logo_with_name_image, height: 150, width: 200),

                Padding(
                  padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_LARGE),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 0,
                        right: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: ColorResources.getGainsBoro(context),
                        ),
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Row(
                          children: [
                            InkWell(
                              onTap: () => _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                              child: Column(
                                children: [
                                  Text(
                                    getTranslated('SIGN_IN', context),
                                    style: authProvider.selectedIndex == 0 ? titilliumSemiBold : titilliumRegular,
                                  ),
                                  Container(
                                    height: 1,
                                    width: 40,
                                    margin: EdgeInsets.only(top: 8),
                                    color: authProvider.selectedIndex == 0 ? color.colortheme : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            InkWell(
                              onTap: () => _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                              child: Column(
                                children: [
                                  Text(
                                    getTranslated('SIGN_UP', context),
                                    style: authProvider.selectedIndex == 1 ? titilliumSemiBold : titilliumRegular,
                                  ),
                                  Container(
                                    height: 1,
                                    width: 50,
                                    margin: EdgeInsets.only(top: 8),
                                    color: authProvider.selectedIndex == 1 ? color.colortheme : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) => PageView.builder(
                      itemCount: 2,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        if (authProvider.selectedIndex == 0) {
                          return SignInWidget();
                        } else {
                          return SignUpWidget();
                        }
                      },
                      onPageChanged: (index) {
                        authProvider.updateSelectedIndex(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
