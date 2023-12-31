import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
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

class BottomCartView extends StatelessWidget {
  final Product product;
  final int auctiondata;
  final customerId;
  final bid;
  final isActive;

  BottomCartView({@required this.product, this.isActive, this.customerId, this.bid, this.auctiondata
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(builder: (context, model, child) {
      return Container(
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
        child: product.producttype != 2
            ? Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
                            },
                            child: Image.asset(
                              Images.cart_arrow_down_image,
                              color: ColorResources.getPrimary(context),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 15,
                            child: Consumer<CartProvider>(
                              builder: (context, cart, child) {
                                return Container(
                                  height: 17,
                                  width: 17,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorResources.getPrimary(context),
                                  ),
                                  child: Text(
                                    cart.cartList.length.toString(),
                                    style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (con) => CartBottomSheet(
                            product: product,
                            callback: () {
                              showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.getPrimary(context),
                        ),
                        child: Text(
                          getTranslated('add_to_cart', context),
                          style: titilliumSemiBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated("Bid Amount", context)+' ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${model.auctionData['start_price']} SR',
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
                        // await model.bidSubmit(context, model, product.id, customerId, bid,'');
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
      );
    });
  }
}
