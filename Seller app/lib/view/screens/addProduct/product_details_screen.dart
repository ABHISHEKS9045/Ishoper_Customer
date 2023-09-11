import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/widget/product_specification_view.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/widget/product_title_view.dart';
import '../../../customproduct/product_image_view.dart';
import '../../../data/model/response/product_model.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/product_details_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/title_row.dart';
import '../faq_and_review_screen.dart';
import '../review/widget/review_widget.dart';
import 'widget/rating_bar.dart';


class ProductDetails extends StatefulWidget {
  final Product product;
  final productType;
  final productId;
  ProductDetails({
    @required this.product, this.productType, this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.product, context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.product.slug.toString(), context);

    // Provider.of<ProductProvider>(context, listen: false)
    //     .initSellerProductList(widget.product.userId.toString(), 1, context);
  }

  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    String ratting = widget.product != null &&
            widget.product.rating != null &&
            widget.product.rating.length != 0
        ? widget.product.rating[0].average.toString()
        : "0";
    _loadData(context);
    return widget.product != null
        ? Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              return Scaffold(
                      backgroundColor: Theme.of(context).cardColor,
                      appBar: AppBar(
                        title: Row(children: [
                          InkWell(
                            child: Icon(Icons.arrow_back_ios,
                                color: Theme.of(context).cardColor, size: 20),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(getTranslated('product_details', context),
                              style: robotoRegular.copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).cardColor)),
                        ]),
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        backgroundColor:
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.black
                                : color.colortheme,
                      ),

                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            widget.product != null
                                ? ProductImageView(images: widget.product.images,isForCustomProduct: false,)
                                : SizedBox(),
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -25.0, 0.0),
                              padding: EdgeInsets.only(
                                  top: Dimensions.FONT_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                    topRight: Radius.circular(
                                        Dimensions.PADDING_SIZE_EXTRA_LARGE)),
                              ),
                              child: Column(
                                children: [

                                  ProductTitleView(
                                      productModel: widget.product),
                                  (widget.product.details != null &&
                                          widget.product.details.isNotEmpty)
                                      ? Container(
                                          height: 250,
                                          margin: EdgeInsets.only(
                                              top: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: ProductSpecification(
                                            productId: widget.productId,

                                            productType: widget.productType,
                                              productSpecification:
                                                  widget.product.details ?? ''),
                                        )
                                      : SizedBox(),
                                  /*widget.product.videoUrl != null
                                      ? YoutubeVideoWidget(
                                          url: widget.product.videoUrl)
                                      : SizedBox(),*/

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        top: Dimensions.PADDING_SIZE_SMALL),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                    color: Theme.of(context).cardColor,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'customer_reviews', context),
                                            style: titilliumSemiBold.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE),
                                          ),

                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                          ),
                                          Container(
                                            width: 230,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: ColorResources.visitShop(
                                                  context),
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RatingBar(
                                                  rating: double.parse(ratting),
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_DEFAULT),
                                                Text('${double.parse(ratting).toStringAsFixed(1)}' +
                                                    ' ' +
                                                    '${getTranslated('out_of_5', context)}'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          Text('${getTranslated('total', context)}' +
                                              ' ' +
                                              '${details.reviewList != null ? details.reviewList.length : 0}' +
                                              ' ' +
                                              '${getTranslated('reviews', context)}'),
                                          details.reviewList != null
                                              ? details.reviewList.length != 0
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[0])
                                                  : SizedBox()
                                              : SizedBox(),
                                          details.reviewList != null
                                              ? details.reviewList.length > 1
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[1])
                                                  : SizedBox()
                                              : SizedBox(),
                                          details.reviewList != null
                                              ? details.reviewList.length > 2
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[2])
                                                  : SizedBox()
                                              : SizedBox(),
                                          InkWell(
                                              onTap: () {
                                                if (details.reviewList !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => ReviewScreen(
                                                              reviewList: details
                                                                  .reviewList)));
                                                }
                                              },
                                              child: details.reviewList !=
                                                          null &&
                                                      details.reviewList
                                                              .length >
                                                          3
                                                  ? Text(
                                                      getTranslated(
                                                          'view_more', context),
                                                      style: titilliumRegular
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    )
                                                  : SizedBox())
                                        ]),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          )
        : SizedBox();
  }
}
