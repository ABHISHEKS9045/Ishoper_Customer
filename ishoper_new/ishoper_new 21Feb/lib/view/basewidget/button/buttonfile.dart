// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, annotate_overrides, use_key_in_widget_constructors, overridden_field, overridden_fields, must_be_immutable
import 'package:flutter/material.dart';

import '../../../utill/color_resources.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final buttonNameloading;
  final Key key;
  bool isLoading;
  final borderRadius;
  final double btnWidth;
  final double btnHeight;
  final Color btnColor;
  final Color btnColorGradientUp;
  final Color btnColorGradientdown;
  final Color borderColor;
  final Color textColor;
  final imageAsset;
  final double elevation;
  final double btnfontsize;
  final btnstyle;

  Button(
      {this.buttonName,
      this.onPressed,
      this.borderRadius,
      this.btnWidth,
      this.btnHeight,
      this.btnColor,
      this.btnColorGradientUp,
      this.btnColorGradientdown,
      this.borderColor,
      this.textColor,
      this.key,
      this.imageAsset,
      this.elevation,
      this.btnstyle,
      this.btnfontsize,
      this.buttonNameloading,
      this.isLoading = false});
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

    return Container(
      height: btnHeight ?? 40.0,
      width: btnWidth ?? screenSize,
      decoration: BoxDecoration(
        // gradient:  LinearGradient(
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //                 colors: [HexColor('#FDCD35'), HexColor('#FD7235')]),
        // color: btnColor ?? Colors.transparent,
        color: isLoading
            ? btnColor ?? color.colortheme.withOpacity(0.6)
            : btnColor ?? color.colortheme,
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      ),
      child: MaterialButton(
        splashColor: Colors.grey,
        // animationDuration: Duration(seconds: 10),
        hoverColor: Colors.black26,

        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        key: key,
        elevation: elevation ?? 3,
        child: imageAsset != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefiximage(), color.sizedboxwidth(8.0), btnname(context)],
              )
            : btnname(context),

        onPressed: isLoading ? null : onPressed,
      ),
    );
  }

  Widget prefiximage() {
    return imageAsset;
  }

  Widget btnname(context) {
    return buttonName != null
        ? Text(buttonName, style: btnstyle ?? buttonTextstyle())
        : buttonlodingtext();
  }

  Widget buttonlodingtext() {
    return isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: color.colorWhite,
                  strokeWidth: 2.5,
                ),
              ),
              color.sizedboxwidth(10.0),
              Text(
                '$buttonNameloading...',
                style: buttonTextstyle(),
              )
            ],
          )
        : Text(buttonNameloading, style: btnstyle ?? buttonTextstyle());
  }

  TextStyle buttonTextstyle() {
    return TextStyle(
      inherit: true,
      color: textColor ?? Colors.white,
      fontFamily: 'Nunito',
      fontWeight: color.fontWeight500,
      fontSize: btnfontsize ?? 17,
      letterSpacing: 0.3,
    );
  }
}