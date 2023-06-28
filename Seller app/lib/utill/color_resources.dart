import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';

class ColorResources {


  static Color visitShop(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFFF4F7FC)
        : Color(0xFFF3F5F9);
  }
// Color colortheme = HexColor("#F3A5AD");
Color colortheme = HexColor("#FFBE81");


  ///F3A5AD
  Color colorlightwhite = HexColor("#FFFCFD");

  static Color getBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? HexColor("#F8AFB8") : HexColor("#F3A5AD");
  }

  static Color getWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color getColombiaBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF678cb5) : Color(0xFF92C6FF);
  }
  static Color getLightSkyBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme     ? Color(0xFFc7c7c7)
        : HexColor("#F8AFB8").withOpacity(0.5);
  }
  static Color getHarlequin(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF257800) : Color(0xFF3FCC01);
  }
  static Color getCheris(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF941546) : Color(0xFFE2206B);
  }
  static Color getGrey(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF808080) : Color(0xFFF1F1F1);
  }
  static Color getRed(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7a1c1c) : Color(0xFFD32F2F);
  }
  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF916129) : Color(0xFFFFAA47);
  }
  static Color getHint(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF9E9E9E);
  }
  static Color getGainsBoro(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF999999) : Color(0xFFE6E6E6);
  }
  static Color getTextBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF414345) : Color(0xFFF3F9FF);
  }
  static Color getIconBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF2e2e2e) : Color(0xFFF9F9F9);
  }
  static Color getHomeBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF343636) : Color(0xFFF3F3F3);
  }
  static Color getImageBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF3f4347) : Color(0xFFE2F0FF);
  }
  static Color getSellerTxt(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF517091) : Color(0xFF92C6FF);
  }
  static Color getChatIcon(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFebebeb) : Color(0xFFD4D4D4);
  }
  static Color getLowGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7d8085) : Color(0xFFEFF6FE);
  }
  static Color getGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF167d3c) : Color(0xFF23CB60);
  }
  static Color getFloatingBtn(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF49698c) : Color(0xFF7DB6F5);
  }
  static Color getPrimary(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFf0f0f0) :  HexColor("#FFBE81");
  }
  static Color getBottomSheetColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF25282B) : Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF52575C);
  }

  static Color getSubTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFA0A0A0) : Color(0xFFA0A0A0);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static const Color BLACK = Color(0xff000000);
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color COLOR_BLUE = Color(0xff00ADE3);
  static const Color COLUMBIA_BLUE = Color(0xff00ADE3);
  static const Color LIGHT_SKY_BLUE = Color(0xff8DBFF6);
  static const Color HARLEQUIN = Color(0xff3FCC01);
  static const Color CERISE = Color(0xffE2206B);
  static const Color GREY = Color(0xffF1F1F1);
  static const Color RED = Color(0xFFD32F2F);
  static const Color YELLOW = Color(0xFFFFAA47);
  static const Color HINT_TEXT_COLOR = Color(0xff9E9E9E);
  static const Color GAINS_BORO = Color(0xffE6E6E6);
  static const Color TEXT_BG = Color(0xFFF4F7FC);
  static const Color ICON_BG = Color(0xffF9F9F9);
  static const Color HOME_BG = Color(0xffF0F0F0);
  static const Color IMAGE_BG = Color(0xffE2F0FF);
  static const Color SELLER_TXT = Color(0xff38DBFF);
  static const Color CHAT_ICON_COLOR = Color(0xffD4D4D4);
  static const Color LOW_GREEN = Color(0xffEFF6FE);
  static const Color GREEN = Color(0xff23CB60);
  static const Color FLOATING_BTN = Color(0xff7DB6F5);
  static const Color COLOR_LIGHT_BLACK = Color(0xFF4A4B4D);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

  static const MaterialColor PRIMARY_MATERIAL = MaterialColor(0xFF192D6B, colorMap);

   Color colorWhite = Colors.white;
  Color colorgrey = Colors.grey;
  Color colorblack = Colors.black;

// Color colortheme = HexColor("#F3A5AD");
// Color colorlightwhite = HexColor("#FFFCFD");
  Color signinbar = HexColor("#F8AFB8");
  Color textColor = HexColor("#2C2C2C");
  Color colorthemedark = HexColor("#F8AFB8");

  double fontsizeheading28 = 28.0;
  double fontsizeheading25 = 25.0;
  double fontsize22 = 22.0;
  double fontsize18 = 18.0;
  double fontsize20 = 20.0;
  double fontsize16 = 16.0;
  double fontsize15 = 15.0;
  double fontsize14 = 14.0;
  double fontsize11 = 11.0;

  double padding20 = 20.0;
  double padding15 = 15.0;
  double padding10 = 10.0;
  double padding8 = 8.0;
  double padding5 = 5.0;

  FontWeight fontWeight600 = FontWeight.w600;
  FontWeight fontWeight700 = FontWeight.w700;
  FontWeight fontWeight900 = FontWeight.bold;
  FontWeight fontWeight400 = FontWeight.w400;
  FontWeight fontWeight500 = FontWeight.w500;
  FontWeight fontWeightnormal = FontWeight.normal;

  TextStyle textstyleHeading1(context) {
    return Theme.of(context).textTheme.headline1;
  }

  TextStyle textstyleHeading2(context) {
    return Theme.of(context).textTheme.headline2;
  }

  TextStyle textstyleHeading3(context) {
    return Theme.of(context).textTheme.headline3;
  }

  TextStyle textstyleHeading6(context) {
    return Theme.of(context).textTheme.headline6;
  }

  TextStyle textstylesubtitle2(context) {
    return Theme.of(context).textTheme.subtitle2;
  }

  TextStyle textstylesubtitle1(context) {
    return Theme.of(context).textTheme.subtitle1;
  }

  double deviceWidth(context, [double size = 1.0]) {
    return MediaQuery.of(context).size.width * size;
  }

  double deviceheight(context, [double size = 1.0]) {
    return MediaQuery.of(context).size.height * size;
  }

  Widget sizedboxheight([height = 20.0]) {
    return SizedBox(
      height: height,
    );
  }

  Widget sizedboxwidth([width = 20.0]) {
    return SizedBox(
      width: width,
    );
  }

  BoxBorder borderCustom() {
    return Border.all(color: colorWhite.withOpacity(0.8), width: 1.5);
  }

  BorderRadius borderRadiuscircular(radius) {
    return BorderRadius.circular(radius);
  }

  Widget dividerVertical() {
    return Container(
      width: 1,
      height: double.maxFinite,
      color: Colors.black12,
    );
  }

  Widget dividerHorizontalblack(context) {
    return Center(
      child: Container(
        width: deviceWidth(context),
        height: 1,
        color: Colors.black12,
      ),
    );
  }

  BorderRadius borderRadius =
      BorderRadius.only(topRight: Radius.circular(35.0));

  boxShadowcontainer() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.07),
        spreadRadius: 3,
        blurRadius: 4,
        offset: Offset(0, 3),
      ),
    ];
  }

  mediaText(context) {
    return MediaQuery.of(context).copyWith(textScaleFactor: 0.9);
  }

  // ignore: non_constant_identifier_names
  width(BuildContext, context) {
    final width = MediaQuery.of(context).size.width;
  }

  height(BuildContext, context) {
    final height = MediaQuery.of(context).size.height;
  }


}
