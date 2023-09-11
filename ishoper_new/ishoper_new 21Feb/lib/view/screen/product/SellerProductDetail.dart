import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ViewProductDetailModel.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ServiceProduct.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/SellerCartScreen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/AddCardModel.dart';
import '../../../helper/product_type.dart';
import '../../../provider/product_provider.dart';
import '../../basewidget/product_widget.dart';
import '../home/widget/products_view.dart';

class SellerProductDetail extends StatefulWidget {
  Datum productList;
  SellerProductDetail(this.productList);

  @override
  State<SellerProductDetail> createState() => _SellerProductDetail();
}

class _SellerProductDetail extends State<SellerProductDetail> {
  SharedPreferences pref;
  bool isLoading = false;
  AddCartProductModel addCartProductModel;

  ColorResources color = ColorResources();
  String imageBaseUrl =
      "https://mactosys.com/iShoper/storage/app/public/custom/product/";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.productList.offers[0].sellers[0].id, 0, context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Row(children: [
          InkWell(
            child: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).cardColor, size: 20),
            onTap: () => Navigator.pop(context),
          ),
          // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Text('Seller Products',
              style: robotoRegular.copyWith(
                  fontSize: 20, color: Theme.of(context).cardColor)),
        ]),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : color.colortheme,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prodProvider, child) {
          return prodProvider.firstLoading ? Center(child: CircularProgressIndicator()):
          StaggeredGridView.countBuilder(
            itemCount: prodProvider.sellerProductList.length,
            crossAxisCount: 2,
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: prodProvider.sellerProductList[index]);
            },
          );
        },
      ),
    );
  }
}
/*
Navigator.push(context,
MaterialPageRoute(builder: (_) {
//SellerModel sellerModel = Provider.of<ChatProvider>(context).uniqueShopList[index].sellerInfo;
//sellerModel.seller.shop = Provider.of<ChatProvider>(context).uniqueShopList[index].shop;
return ProductView(isHomePage: false, productType: ProductType.SELLER_PRODUCT, sellerId: viewProductDetailModel.data[0].offers[index].sellers[0].image);
}));
*/
