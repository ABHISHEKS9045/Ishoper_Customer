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
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/auction_bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/auction_product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/auction_product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_video_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../provider/profile_provider.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import 'faq_and_review_screen.dart';

class AuctionProductDetails extends StatefulWidget {
  final auctionProduct;

  AuctionProductDetails({
    this.auctionProduct,
  });

  @override
  State<AuctionProductDetails> createState() => _AuctionProductDetailsState();
}

class _AuctionProductDetailsState extends State<AuctionProductDetails> {
  String TAG = "_ProductDetailsState";
  var countBids;
  var customerId;
  var listner;
  var productId = '';

  void getFirebaseData(String child) {
    listner = FirebaseDatabase.instance.ref().child(child).onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;
      debugPrint("$TAG snapshot ======> $snapshot");
      if (snapshot.exists) {
        debugPrint("$TAG snapshot child ======> ${snapshot.value}");

        setState(() {
          countBids = snapshot.value;
        });
        debugPrint("$TAG countBids ======> $countBids");

        /// response of the auction
        /// {latest_bid: 70, is_active: 1, product_id: 218, bid_user_count: 2, reserve_price: 0}
      }
    });
  }

  @override
  void initState() {
    super.initState();
    productId = widget.auctionProduct['id'].toString();
    print("$TAG Auction product id ============> ${widget.auctionProduct["id"]}");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = Provider.of<ProductDetailsProvider>(context, listen: false);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      final productModel = Provider.of<ProductProvider>(context, listen: false);
      final walletModel = Provider.of<WalletTransactionProvider>(context, listen: false);

      await model.auctionDetails(context, productId);
      _loadData(context, model, productModel);

      profile.getUserInfo(context);

      customerId = profile.customerId;

      walletModel.getWalletAmount(customerId);

      print("$TAG customerId  ============> $customerId");
      print("$TAG Auction product ============> ${widget.auctionProduct}");
      print("$TAG Auction product id ============> ${widget.auctionProduct["id"]}");


      getCountdown(context, model);
      getCountdown1(context, model);
      print("$TAG countdown ==========> ${model.days} day(s) ${model.hours} hour(s) ${model.minutes} minute(s) ${model.seconds} second(s).");
      print("$TAG countdown ==========> ${model.days1} day(s) ${model.hours1} hour(s) ${model.minutes1} minute(s) ${model.seconds1} second(s).");
      model.diff = model.upComingIn.add(Duration(seconds: 1));
      var Upcoming = model.diff;
      print(" diffdataaUpcoming=============>$Upcoming");
      getFirebaseData("product_$productId");

    });
  }

  @override
  void dispose() {
    if (listner != null) {
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

    model.removePrevReview();
    // model.initProduct(widget.auctionProduct, context);
    productModel.removePrevRelatedProduct();
    productModel.initRelatedProductList(productId.toString(), context);
    model.getCount(productId.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false).checkWishList(productId.toString(), context);
    }
  }

  ColorResources color = ColorResources();

  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    ScrollController _scrollController = ScrollController();
    String ratting = widget.auctionProduct != null && widget.auctionProduct["rating"] != null && widget.auctionProduct['rating'].length != 0 ? widget.auctionProduct['rating'][0].average.toString() : "0";
    return widget.auctionProduct != null
        ? Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              return details.hasConnection
                  ? ModalProgressHUD(
                  inAsyncCall: details.is_loding,
                  opacity: 0.7,
                  progressIndicator: CircularProgressIndicator(
                    color: Colors.orange,
                  ), child:
              Scaffold(
                      backgroundColor: Theme.of(context).cardColor,
                      appBar: AppBar(
                        title: Row(children: [
                          InkWell(
                            child: Icon(Icons.arrow_back_ios, color: Theme.of(context).cardColor, size: 20),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            getTranslated('Auction product_details',context),
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
                      bottomNavigationBar: AuctionBottomCartView(
                        customerId: customerId,
                        isActive: countBids == null ? details.isActivedata : countBids["is_active"],

                        // Upcoming : details.diff.isAfter(currentDateTime) == "UpComing In" ,

                        bid: countBids,
                        productModel: widget.auctionProduct,
                        bidCont: details.bidController.text.toString(),
                      ),
                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            widget.auctionProduct != null ? AuctionProductImageView(productModel: widget.auctionProduct) : SizedBox(),
                            Container(
                              transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                              padding: EdgeInsets.only(top: Dimensions.FONT_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE), topRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE)),
                              ),
                              child: Column(
                                children: [
                                  AuctionProductTitleView(
                                    // isActive: details.isActivedata,
                                    isActive: countBids == null ? details.isActivedata : countBids["is_active"],

                                    countBids: countBids,
                                    productModel: widget.auctionProduct,
                                  ),
                                  details.isActivedata == 1 ? Container(
                                    margin: EdgeInsets.only(right: 20, left: 20),
                                    child: CustomTextField(
                                      controller: details.bidController,
                                      hintText: getTranslated('ENTER Bid Amount',context),
                                      textInputAction: TextInputAction.done,
                                      textInputType: TextInputType.numberWithOptions(),
                                    ),
                                  ):
                                      Container(),


                                  (widget.auctionProduct['details'] != null && widget.auctionProduct['details'].isNotEmpty)
                                      ? Container(
                                          height: 250,
                                          margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                          child: ProductSpecification(productSpecification: widget.auctionProduct['details'] ?? ''),
                                        )
                                      : SizedBox(),
                                  widget.auctionProduct['videoUrl'] != null ? YoutubeVideoWidget(url: widget.auctionProduct['videoUrl']) : SizedBox(),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.FONT_SIZE_DEFAULT),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: PromiseScreen(),
                                  ),
                                  widget.auctionProduct['addedBy'] == 'seller'
                                      ? SellerView(
                                          sellerId: widget.auctionProduct['userId'].toString(),
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
                                  widget.auctionProduct['addedBy'] == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                          child: TitleRow(title: getTranslated('more_from_the_shop', context), isDetailsPage: true),
                                        )
                                      : SizedBox(),
                                  widget.auctionProduct['addedBy'] == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          child: ProductView(isHomePage: true, productType: ProductType.SELLER_PRODUCT, scrollController: _scrollController, sellerId: widget.auctionProduct['userId'].toString()),
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
                    ))
                  : Scaffold(body: NoInternetOrDataScreen(isNoInternet: true, child: AuctionProductDetails(auctionProduct: widget.auctionProduct)));
            },
          )
        : SizedBox();
  }
}
