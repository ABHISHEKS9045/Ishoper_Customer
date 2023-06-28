import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../provider/product_details_provider.dart';

class AuctionBottomCartView extends StatelessWidget {
  final productModel;
  final customerId;
  final bid;
  final isActive;
  final String bidCont;

  AuctionBottomCartView({@required this.productModel, this.isActive, this.customerId, this.bid, this.bidCont,});
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(builder: (context, model, child) {
      return

        productModel["error"] != false ?
         Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(
                  context,
                ).darkTheme
                    ? 700
                    : 300],
                blurRadius: 15,
                spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTranslated("Bid Amount", context) + ' ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  '${model.starprice} SR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final model1 = Provider.of<ProductDetailsProvider>(context, listen: false);

                  await model.bidSubmit(context, model, productModel["id"], customerId, bid, bidCont).whenComplete(() {
                    model1.bidController.clear();
                  });


                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.getPrimary(context),
                  ),
                  child: Text(
                    getTranslated('Place Bid', context),
                    style: titilliumSemiBold.copyWith(
                      fontSize: 17,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ):Container(
          height: 60,
            alignment: Alignment.center,
            
            child: Text(" Auction is over now because auction \n reached to maximum amount limit" ,
              style: titilliumSemiBold.copyWith(
                fontSize: 17,
                color: Colors.black87,),
            )

        );
    });
  }
}
