import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources2.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final Color backgroundColor;
  CustomButton({this.onTap, @required this.btnTxt, this.backgroundColor});
  ColorResources color = ColorResources();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0),
        backgroundColor: onTap == null ? ColorResources.getGrey(context) : backgroundColor == null ? color.colortheme: backgroundColor,
      ),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)), // changes position of shadow
            ],
            gradient: (Provider.of<ThemeProvider>(context).darkTheme || onTap == null) ? null : LinearGradient(colors: [
              color.colortheme,
              color.colortheme,
              color.colortheme,
            ]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(btnTxt,
            style: titilliumSemiBold.copyWith(
              fontSize: 16,
              color: Theme.of(context).highlightColor,
            )),
      ),
    );
  }
}
