import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class NoShippingDataScreen extends StatelessWidget {
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          Image.asset(
            Images.shipping,
            width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
            color: color.colortheme,
          ),

          Text(
            getTranslated('no_shipping_method', context),
            style: titilliumBold.copyWith(color:color.colortheme, fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
