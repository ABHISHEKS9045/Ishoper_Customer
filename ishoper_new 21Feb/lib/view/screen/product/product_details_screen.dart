import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_video_widget.dart';
import 'package:provider/provider.dart';

import '../../../provider/profile_provider.dart';
import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({
    @required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String TAG = "_ProductDetailsState";
  var countBids;
  var customerId;
  var listner;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = Provider.of<ProductDetailsProvider>(context, listen: false);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      final productModel = Provider.of<ProductProvider>(context, listen: false);
      final walletModel = Provider.of<WalletTransactionProvider>(context, listen: false);
      profile.getUserInfo(context);
      customerId = profile.customerId;

      walletModel.getTransactionList(context, 1);

      print("$TAG customerId  ============> $customerId");
      print("$TAG Product ID ============> ${widget.product.id}");

      _loadData(context, model, productModel);
      getCountdown(context, model);
      getCountdown1(context, model);
      print("$TAG countdown ==========> ${model.days} day(s) ${model.hours} hour(s) ${model.minutes} minute(s) ${model.seconds} second(s).");
      print("$TAG countdown ==========> ${model.days1} day(s) ${model.hours1} hour(s) ${model.minutes1} minute(s) ${model.seconds1} second(s).");
      model.diff = model.upComingIn.add(Duration(seconds: 1));
      print("$TAG Diff Sate Time=======> ${model.diff}");
    });
  }

  @override
  void dispose() {
    if(listner != null) {
      listner.cancel();
    }
    super.dispose();
  }

  getCountdown(BuildContext context, ProductDetailsProvider model) {
    DateTime currentTime = DateTime.now();
    Duration difference = model.upComingIn.difference(currentTime);
    model.days = difference.inDays;
    model.hours = difference.inHours % 24;
    model.minutes = difference.inMinutes % 60;
    model.seconds = difference.inSeconds % 60;
  }

  getCountdown1(BuildContext context, ProductDetailsProvider model) {
    DateTime currentTime = DateTime.now();
    Duration difference1 = model.endIn.difference(currentTime);
    model.days1 = difference1.inDays;
    model.hours1 = difference1.inHours % 24;
    model.minutes1 = difference1.inMinutes % 60;
    model.seconds1 = difference1.inSeconds % 60;
  }

  _loadData(BuildContext context, ProductDetailsProvider model, ProductProvider productModel) async {
    await model.auctionDetails(context, widget.product.id);
    model.removePrevReview();
    model.initProduct(widget.product, context);
    productModel.removePrevRelatedProduct();
    productModel.initRelatedProductList(widget.product.id.toString(), context);
    model.getCount(widget.product.id.toString(), context);
    // model.getSharableLink(widget.product.slug.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false).checkWishList(widget.product.id.toString(), context);
    }
    productModel.initSellerProductList(widget.product.userId.toString(), 1, context);
  }

  ColorResources color = ColorResources();

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    String ratting = widget.product != null && widget.product.rating != null && widget.product.rating.length != 0 ? widget.product.rating[0].average.toString() : "0";
    //_loadData(context);
    return widget.product != null
        ? Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              return
                details.hasConnection
                  ? Scaffold(
                      backgroundColor: Theme.of(context).cardColor,
                      appBar: AppBar(
                        title: Row(children: [
                          InkWell(
                            child: Icon(Icons.arrow_back_ios, color: Theme.of(context).cardColor, size: 20),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            getTranslated('product_details', context),
                            style: robotoRegular.copyWith(
                              fontSize: 20,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ]),
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : color.colortheme,
                      ),
                      bottomNavigationBar: BottomCartView(customerId: customerId, bid: countBids, product: widget.product),
                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            widget.product != null ? ProductImageView(productModel: widget.product) : SizedBox(),
                            Container(
                              transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                              padding: EdgeInsets.only(top: Dimensions.FONT_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE), topRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE)),
                              ),
                              child: Column(
                                children: [
                                  ProductTitleView(
                                      countBids: countBids,
                                      // isActive: details.auctionData['is_active'],
                                      productModel: widget.product),
                                  (widget.product.details != null && widget.product.details.isNotEmpty)
                                      ? Container(
                                          height: 250,
                                          margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                          child: ProductSpecification(productSpecification: widget.product.details ?? ''),
                                        )
                                      : SizedBox(),
                                  widget.product.videoUrl != null ? YoutubeVideoWidget(url: widget.product.videoUrl) : SizedBox(),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.FONT_SIZE_DEFAULT),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: PromiseScreen(),
                                  ),
                                  widget.product.addedBy == 'seller'
                                      ? SellerView(
                                          sellerId: widget.product.userId.toString(),
                                        )
                                      : SizedBox.shrink(),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                    color: Theme.of(context).cardColor,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      Text(
                                        getTranslated('customer_reviews', context),
                                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      Container(
                                        width: 230,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: ColorResources.visitShop(context),
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RatingBar(
                                              rating: double.parse(ratting),
                                              size: 18,
                                            ),
                                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                            Text('${double.parse(ratting).toStringAsFixed(1)}' + ' ' + '${getTranslated('out_of_5', context)}'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                      Text('${getTranslated('total', context)}' + ' ' + '${details.reviewList != null ? details.reviewList.length : 0}' + ' ' + '${getTranslated('reviews', context)}'),
                                      details.reviewList != null
                                          ? details.reviewList.length != 0
                                              ? ReviewWidget(reviewModel: details.reviewList[0])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      details.reviewList != null
                                          ? details.reviewList.length > 1
                                              ? ReviewWidget(reviewModel: details.reviewList[1])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      details.reviewList != null
                                          ? details.reviewList.length > 2
                                              ? ReviewWidget(reviewModel: details.reviewList[2])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      InkWell(
                                          onTap: () {
                                            if (details.reviewList != null) {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewScreen(reviewList: details.reviewList)));
                                            }
                                          },
                                          child: details.reviewList != null && details.reviewList.length > 3
                                              ? Text(
                                                  getTranslated('view_more', context),
                                                  style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor),
                                                )
                                              : SizedBox())
                                    ]),
                                  ),
                                  widget.product.addedBy == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                          child: TitleRow(title: getTranslated('more_from_the_shop', context), isDetailsPage: true),
                                        )
                                      : SizedBox(),
                                  widget.product.addedBy == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          child: ProductView(isHomePage: true, productType: ProductType.SELLER_PRODUCT, scrollController: _scrollController, sellerId: widget.product.userId.toString()),
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          child: TitleRow(title: getTranslated('related_products', context), isDetailsPage: true),
                                        ),
                                        SizedBox(height: 5),
                                        RelatedProductView(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Scaffold(body: NoInternetOrDataScreen(isNoInternet: true, child: ProductDetails(product: widget.product)));
            },
          )
        : SizedBox();
  }
}
