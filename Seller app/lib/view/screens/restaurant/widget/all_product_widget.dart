import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/provider/localization_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/product_shimmer.dart';
import 'package:sixvalley_vendor_app/view/base/product_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/add_product_screen.dart';

import '../../addProduct/widget/add_product_next_Screen.dart';

class ProductView extends StatelessWidget {
  final int sellerId;
  final productType;

  ProductView({@required this.sellerId, this.productType});
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {


    final ScrollController scrollController = ScrollController();
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).sellerProductList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        pageSize = (Provider.of<ProductProvider>(context, listen: false).sellerPageSize/10).ceil();

        if(Provider.of<ProductProvider>(context, listen: false).offset < pageSize) {
          Provider.of<ProductProvider>(context, listen: false).setOffset(Provider.of<ProductProvider>(context, listen: false).offset+1);
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();

          Provider.of<ProductProvider>(context, listen: false).initSellerProductList(
            sellerId.toString(), Provider.of<ProductProvider>(context, listen: false).offset,context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode == 'US'?'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase());

        }
      }
      print('productType :$productType');

    });


    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {

        List<Product> productList;
        productList = prodProvider.sellerProductList;


        return Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                !prodProvider.firstLoading ? productList.length != 0 ? ListView.builder(
                  itemCount: productList.length,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(productModel: productList[index]);
                  },
                ) : SizedBox.shrink() : ProductShimmer(isEnabled: prodProvider.firstLoading),

                prodProvider.isLoading ? Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(
                    color: color.colortheme,
                    valueColor: AlwaysStoppedAnimation<Color>(color.colorWhite)),
                )) : SizedBox.shrink(),

              ]),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: (){

                  debugPrint("on add product clicked");

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(
                    productType: productType,

                  )));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color:color.colortheme
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Center(child: Image.asset(Images.add_btn)),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

