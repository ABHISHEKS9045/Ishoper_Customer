// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/top_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/mycartpage.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/myproduct.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/top_seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/SellerProductDetail.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/all_top_seller_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/yourProductdetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/model/ViewProductDetailModel.dart';
import '../../../../data/model/ViewProductModel.dart';
import '../../../../helper/product_type.dart';
import '../../../../provider/ServiceProduct.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/no_internet_screen.dart';
import '../../home/widget/products_view.dart';
import '../../product/SellerDetails.dart';
import '../../product/product_details_screen.dart';
import '../chat_screen.dart';

class OfferPage extends StatefulWidget {
  final TopSellerModel topSeller;
  final int topSellerId;
  DatumProduct dataProduct;
  OfferPage(this.dataProduct, {Key key, this.topSeller, this.topSellerId})
      : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  void initState() {
    super.initState();
    viewProductDetailApi();
  }

  SharedPreferences pref;
  bool isLoading = false;
  ViewProductDetailModel viewProductDetailModel;
  String sellerName = "";
  String PriceOffer = "";


  void viewProductDetailApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    viewProductDetailModel = await ServiceProduct().viewProductDetail(
        pref.getString(AppConstants.TOKEN).toString(),
        widget.dataProduct.id.toString());

    if (viewProductDetailModel.status == 200) {
      print(widget.dataProduct.id.toString());
      for (var i = 0; i < viewProductDetailModel.data.length; i++) {
        for (var j = 0;
            j < viewProductDetailModel.data[i].offers[i].sellers.length;
            j++) {
          sellerName =
              viewProductDetailModel.data[i].offers[i].sellers[j].fullName;
          PriceOffer = viewProductDetailModel.data[i].offers[i].offers;
        }
      }
      print("Susseccessfully");
    } else {
      print("errorr product detail ");
    }

    setState(() {
      isLoading = true;
    });
  }

  String imageBaseUrl =
      "https://mactosys.com/iShoper/storage/app/public/custom/product/";

  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          color.sizedboxheight(35.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              color.sizedboxwidth(20.0),
              Padding(
                padding: const EdgeInsets.only(right: 90.0),
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Card(

                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(Icons.arrow_back,color: color.colortheme,),
                      ),
                    )),
              ),
              Text(
                "Offers",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 24.0,
                    color: color.textColor,
                    fontWeight: color.fontWeight600),
              ),
            ],
          ),
          color.sizedboxheight(20.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your Products",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16.0, fontWeight: color.fontWeight600),
            ),
          ),
          GestureDetector(
            onTap: (){
              print(widget.dataProduct.images);
              Get.to(()=>YourProductDetails(
                name: widget.dataProduct.name,
                images: widget.dataProduct.images,
                color: widget.dataProduct.color.first.name,
                size: widget.dataProduct.size,
                description: widget.dataProduct.description,

                image:imageBaseUrl + '/' + widget.dataProduct.images[0] ,

              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 15),
                  // height: 110.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [HexColor("#FFBE81").withOpacity(0.35), HexColor("#FFBE81").withOpacity(0.35)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          width: 25.w,
                          height: 25.w,
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child:
                            widget.dataProduct.images!= null && widget.dataProduct.images.length!=0 ?
                            CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageBaseUrl +
                                    '/' +
                                    widget.dataProduct.images[0]) :
                            Image.asset(Images.placeholder),
                          )
                      ),
                      SizedBox(width: 4.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width:55.w,
                                child: Text(
                                  widget.dataProduct.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19.0,
                                      fontWeight:
                                      color.fontWeight500),
                                ),
                              ),
                              // Image.asset("assets/images/delete1.png"),
                            ],
                          ),
                          color.sizedboxheight(5.0),
                          SizedBox(height: 1.h,),
                          Row(
                            children: [
                              Text(
                                "Size : " +
                                    widget.dataProduct.size,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Text(
                                "Color : " +
                                    widget.dataProduct.color.first.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 1.h,),
                          Text(
                            widget.dataProduct.availableOffers
                                .toString() + " Offers",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: color.colortheme,
                                fontSize: 18.0,
                                fontWeight:
                                color.fontWeight700),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Recent Offers",
              style: TextStyle(
                  color: color.colorblack,
                  fontSize: 14.0,
                  fontWeight: color.fontWeight600),
            ),
          ),
          Expanded(
            child: isLoading
                ? Container(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child:viewProductDetailModel.data!=null &&   viewProductDetailModel.data[0].offers.length != 0
                          ? ListView.builder(
                              itemCount: viewProductDetailModel.data[0].offers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.all(10),
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  viewProductDetailModel.data[0].offers[index].sellers[0].fullName
                                                      ,
                                                  style: TextStyle(
                                                      color: color.colorblack,
                                                      fontSize: 19.0,
                                                      fontWeight:
                                                          color.fontWeight600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Price Offered : Rs." +
                                                    (viewProductDetailModel.data[0].offers[index].product.length!=0 ? viewProductDetailModel.data[0].offers[index].product[0].unitPrice.toString() : ''),
                                                style: TextStyle(
                                                    color: HexColor("#747474"),
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (_) {
                                                    //SellerModel sellerModel = Provider.of<ChatProvider>(context).uniqueShopList[index].sellerInfo;
                                                    //sellerModel.seller.shop = Provider.of<ChatProvider>(context).uniqueShopList[index].shop;
                                                    return ChatScreen(
                                                        seller: null,
                                                        shopId: viewProductDetailModel.data[0].offers[index].product[0].userId,
                                                        shopName: viewProductDetailModel.data[0].offers[index].sellers[0].fullName,
                                                        image: viewProductDetailModel.data[0].offers[index].sellers[0].image);
                                                  }));
                                            },
                                            icon: Image.asset(Images.chat_image, color: color.colortheme, height: Dimensions.ICON_SIZE_DEFAULT),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.all(8.0),
                                              // width: 150.0,
                                              decoration: BoxDecoration(
                                                  color: HexColor(" #FFFFFF"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  border: Border.all(
                                                      color: color.colortheme)),
                                              child: ElevatedButton(
                                                onPressed: () {


                                                  Get.to(() => SellerDetails(
                                                      viewProductDetailModel
                                                          .data[0],index
                                                  ));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  onSurface: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                                child: Text(
                                                  "Seller Details",
                                                  style: TextStyle(
                                                      color: color.colortheme,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          color.fontWeight500),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.all(8.0),
                                              // width: 150.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    color.colortheme,
                                                    color.colortheme
                                                  ],
                                                ),
                                              ),
                                              child: ElevatedButton(
                                                ////#F79294
                                                onPressed: () {
                                                  /*Get.to(() =>
                                                      SellerProductDetail(
                                                          viewProductDetailModel
                                                              .data[index]));*/
                                                  if(viewProductDetailModel.data[0].offers[index].product.length!=0) {
                                                    Get.to(() =>
                                                        ProductDetails(
                                                            product: viewProductDetailModel
                                                                .data[0]
                                                                .offers[index]
                                                                .product[0]));
                                                  }
                                                  else{
                                                    Fluttertoast.showToast(msg: 'Product Removed By Seller!!');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  onSurface: Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                ),
                                                child: Text(
                                                  "View Product ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          color.fontWeight500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : NoInternetOrDataScreen(isNoInternet: false),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: color.colortheme,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

ColorResources color = ColorResources();

// Widget sellerDetail(context) {
//   return Container(
//     margin: EdgeInsets.all(8.0),
//     // width: 150.0,
//     decoration: BoxDecoration(
//         color: HexColor(" #FFFFFF"),
//         borderRadius: BorderRadius.circular(15.0),
//         border: Border.all(color: color.colortheme)),
//     child: ElevatedButton(
//       onPressed: () {
//         Get.to(() => AllTopSellerScreen(topSeller: null));
//       },
//       style: ElevatedButton.styleFrom(
//         primary: Colors.transparent,
//         onSurface: Colors.transparent,
//         shadowColor: Colors.transparent,
//       ),
//       child: Text(
//         "Seller Details",
//         style: TextStyle(
//             color: color.colortheme,
//             fontSize: 16.0,
//             fontWeight: color.fontWeight500),
//       ),
//     ),
//   );
// }

// Widget viewProduct(context, model) {
//   return Container(
//     margin: EdgeInsets.all(8.0),
//     // width: 150.0,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.0),
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [HexColor("#E07B7D"), HexColor("#F79294")],
//         )),
//     child: ElevatedButton(
//       ////#F79294
//       onPressed: () {
//         Get.to(() => SellerProductDetail(model));
//       },
//       style: ElevatedButton.styleFrom(
//         primary: Colors.transparent,
//         onSurface: Colors.transparent,
//         shadowColor: Colors.transparent,
//       ),
//       child: Text(
//         "View Product ",
//         style: TextStyle(fontSize: 16.0, fontWeight: color.fontWeight500),
//       ),
//     ),
//   );
// }
