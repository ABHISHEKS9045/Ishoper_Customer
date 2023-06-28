import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../helper/price_converter.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/rating_bar.dart';
import '../../chat/widget/mycartpage.dart';
import '../../product/product_details_screen.dart';

class ProductViewList extends StatelessWidget {
  final bool isHomePage;
  final productModel;
  final ProductType productType;
  final ScrollController scrollController;
  final String sellerId;
  ProductViewList({@required this.isHomePage, @required this.productType, this.scrollController, this.sellerId, this.productModel});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    if(productType == ProductType.SELLER_PRODUCT) {
      Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, offset, context);
    }else{
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(offset, context);
    }
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).auctionDataList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).filterIsLoading) {
        int pageSize;
        if(productType == ProductType.BEST_SELLING || productType == ProductType.TOP_PRODUCT || productType == ProductType.NEW_ARRIVAL ) {
          pageSize = (Provider.of<ProductProvider>(context, listen: false).latestPageSize/10).ceil();
          offset = Provider.of<ProductProvider>(context, listen: false).lOffset;
        }

        else if(productType == ProductType.SELLER_PRODUCT) {
          pageSize = (Provider.of<ProductProvider>(context, listen: false).sellerPageSize/10).ceil();
          offset = Provider.of<ProductProvider>(context, listen: false).sellerOffset;
        }
        if(offset < pageSize) {
          print('offset =====>$offset and page sige ====>$pageSize');
          offset++;

          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();


          if(productType == ProductType.SELLER_PRODUCT) {
            Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, offset, context);
          }else{
            Provider.of<ProductProvider>(context, listen: false).getLatestProductList(offset, context);
          }

        }else{

        }
      }

    });

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList = [];



        return Column(children: [


          !prodProvider.filterFirstLoading ? productList.length != 0 ?
          StaggeredGridView.countBuilder(
            itemCount: prodProvider.auctionDataList.length,
            crossAxisCount: 2,
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
               String ratting =
              productModel["rating"] != null && productModel['rating'].length != 0
                  ? productModel["rating"][0]["average"]
                  : "0";
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 1000),
                      pageBuilder: (context, anim1, anim2) =>
                          ProductDetails(product: productModel),


                    ),


                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.5,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
                  ),
                  child: Stack(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Product Image
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.width / 2.50,
                              decoration: BoxDecoration(
                                color: ColorResources.getIconBg(context),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  fit: BoxFit.cover,
                                  height: MediaQuery.of(context).size.width / 2.45,
                                  image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${productModel.thumbnail}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholder_1x1,
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.width / 2.45),
                                ),
                              ),
                            ),
                          ),

                          // Product Details
                          Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL,
                                bottom: 5,
                                left: 5,
                                right: 5),
                            child: Container(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(productModel.name ?? '',
                                        textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          RatingBar(
                                            rating: double.parse(ratting),
                                            size: 18,
                                          ),
                                          Text(
                                              '(${productModel['reviewCount'].toString() ?? 0})',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                              )),
                                        ]),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    productModel.discount != null && productModel.discount > 0
                                        ? Text(
                                      PriceConverter.convertPrice(
                                          context, productModel['unitPrice']),
                                      style: titleRegular.copyWith(
                                        color:HexColor('#828282') ,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      ),
                                    )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(
                                          context, productModel['unitPrice'],
                                          discountType: productModel['discountType'],
                                          discount: productModel['discount']),
                                      style:
                                      titilliumSemiBold.copyWith(color: color.Pricecolor
                                        // ColorResources.getPrimary(context)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),

                    // Off

                    productModel['discount'] > 0
                        ? Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 20,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: color.colortheme,
                          // ColorResources.getPrimary(context),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            PriceConverter.percentageCalculation(
                                context,
                                productModel['unitPrice'],
                                productModel['discount'],
                                productModel['discountType']),
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).highlightColor,
                                fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ]),
                ),
              );

                // ProductWidget(productModel: productList[index]);






            },
          ) : SizedBox.shrink(): ProductShimmer(isHomePage: isHomePage ,isEnabled: prodProvider.firstLoading),

          prodProvider.filterIsLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}

