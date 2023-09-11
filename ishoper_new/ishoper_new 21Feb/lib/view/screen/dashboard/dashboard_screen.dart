import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/myproduct.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/more_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:provider/provider.dart';

import '../../../utill/color_resources.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;
  List<Widget> _screens;
  ColorResources color = ColorResources();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";

    _screens = [
      HomePage(),
      singleVendor ? OrderScreen(isBacButtonExist: false)
          : MyProductPage(),
      // : InboxScreen(isBackButtonExist: false),
      OrderScreen(
        isBacButtonExist: false,
      ),
      // ? NotificationScreen(isBacButtonExist: false)
      // :
      // OrderScreen(isBacButtonExist: false),
      // singleVendor ? MoreScreen() : NotificationScreen(isBacButtonExist: false),
      singleVendor ? SizedBox() : MoreScreen(),
    ];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: color.colortheme,
          //  Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodyLarge.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        color: index == _pageIndex
            ? color.colortheme
            // Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.5),
        height: 25,
        width: 25,
      ),
      label: label,
    );
  }

  // BottomNavigationBarItem _barItem(String icon, int index) {
  //   return BottomNavigationBarItem(
  //     icon: Image.asset(
  //       icon,
  //       color: index == _pageIndex
  //           ? Theme.of(context).primaryColor
  //           : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
  //       height: 25,
  //       width: 25,
  //     ),
  //     // label: label,
  //   );
  // }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> _list = [];

    // if (!isSingleVendor) {
    //   _list.add(_barItem(Images.home_image, 0));
    //   _list.add(_barItem(Images.my_product, 1));
    //   _list.add(_barItem(Images.my_cart, 2));
    //   _list.add(_barItem(Images.notification, 3));
    //   _list.add(_barItem(Images.more_image, 4));
    // } else {
    //   _list.add(_barItem(Images.home_image, 0));
    //   _list.add(_barItem(Images.shopping_image, 1));
    //   _list.add(_barItem(Images.notification, 2));
    //   _list.add(_barItem(Images.more_image, 3));
    // }

    if (!isSingleVendor) {
      _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
      _list.add(_barItem(Images.my_product, getTranslated('products', context), 1));
      _list.add(_barItem(Images.my_cart, getTranslated('orders', context), 2));
      // _list.add(_barItem(
      //     Images.notification, getTranslated('notification', context), 3));
      _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    } else {
      _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
      _list.add(_barItem(Images.shopping_image, getTranslated('orders', context), 1));
      _list.add(_barItem(Images.notification, getTranslated('notification', context), 2));
      _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    }

    return _list;
  }
}
