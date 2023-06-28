import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/auction_model.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../provider/product_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/auction_widget.dart';
import '../../../basewidget/product_shimmer.dart';
import '../../../basewidget/rating_bar.dart';
import '../../chat/widget/mycartpage.dart';
import '../../product/auction_details_screen.dart';
import '../../product/product_details_screen.dart';

class Auctionviewproduct extends StatefulWidget {
  final ScrollController scrollController;

  Auctionviewproduct({
    this.scrollController,

  });

  @override
  State<Auctionviewproduct> createState() => _AuctionviewproductState();
}

class _AuctionviewproductState extends State<Auctionviewproduct> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = Provider.of<ProductProvider>(context, listen: false);
      await model.auctionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, model, _) {
        return Column(children: [
          Container(
            height: MediaQuery.of(context).size.width / 1.45,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.auctionDataList.length,
                itemBuilder: (ctx, int index) {
                  String ratting = model.auctionDataList[index]["rating"] != null && model.auctionDataList[index]["rating"].length != 0 ? model.auctionDataList[index]["average"] : "0";

                  return Container(
                      width: (MediaQuery.of(context).size.width / 2) - 20,
                      child: InkWell(
                        onTap: () {

                          print("AuctionId===================>${model.auctionDataList[index]}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuctionProductDetails(auctionProduct: model.auctionDataList[index])));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 1.5,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).highlightColor,
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: Stack(children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              // Product Image
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.width / 2.50,
                                  decoration: BoxDecoration(
                                    color: ColorResources.getIconBg(context),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.width / 2.45,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${model.auctionDataList[index]["thumbnail"]}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1, fit: BoxFit.cover, height: MediaQuery.of(context).size.width / 2.45),
                                    ),
                                  ),
                                ),
                              ),

                              // Product Details
                              Padding(
                                padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL, bottom: 5, left: 5, right: 5),
                                child: Container(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(model.auctionDataList[index]["name"] ?? '', textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, fontWeight: FontWeight.w400), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          RatingBar(
                                            rating: double.parse(ratting),
                                            size: 18,
                                          ),
                                          Text('(${model.auctionDataList[index]["review_Count"].toString() ?? 0})',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                              )),
                                        ]),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        model.auctionDataList[index]["discount"] != null && model.auctionDataList[index]["discount"] > 0
                                            ? Text(
                                                PriceConverter.convertPrice(context, model.auctionDataList[index]["unit_price"]),
                                                style: titleRegular.copyWith(
                                                  color: HexColor('#828282'),
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
                                          PriceConverter.convertPrice(context, double.parse(model.auctionDataList[index]["unit_price"].toString()), discountType: model.auctionDataList[index]["discount_type"], discount: double.parse(model.auctionDataList[index]["discount"].toString())),
                                          style: titilliumSemiBold.copyWith(color: color.Pricecolor
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

                            model.auctionDataList[index]["discount"] > 0
                                ? Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      height: 20,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        color: color.colortheme,
                                        // ColorResources.getPrimary(context),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          PriceConverter.percentageCalculation(context, model.auctionDataList[index]["unit_price"], model.auctionDataList[index]["discount"], model.auctionDataList[index]["discount_type"]),
                                          style: robotoRegular.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ]),
                        ),
                      )

                      // ProductWidget1(productModel: model.auctionDataList[index])
                      );
                }),
          )

        ]);
      },
    );
  }
}
