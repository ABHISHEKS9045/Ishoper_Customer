import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/ViewProductDetailModel.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/dimensions.dart';
import '../chat/chat_screen.dart';
import 'SellerProductDetail.dart';

class SellerDetails extends StatefulWidget {
  Datum productList;
  int index;
  SellerDetails(this.productList,this.index ,{Key key}) : super(key: key);

  @override
  State<SellerDetails> createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  ColorResources color = ColorResources();
  String imageBaseUrl = "${AppConstants.BASE_URL}storage/app/public/seller/";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        centerTitle: true,
        title: Row(children: [
          InkWell(
            child: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).cardColor, size: 20),
            onTap: () => Navigator.pop(context),
          ),

          SizedBox(width: 100,),
          // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Text('Seller Details',
              style: robotoRegular.copyWith(
                  fontSize: 20, color: Theme.of(context).cardColor)),
        ]),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : color.colortheme,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          child: Column(
            children: [
              Container(
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: Images.placeholder,
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}' +
                      '/' +
                      widget.productList.offers[widget.index].sellers[0].image,
                  imageErrorBuilder: (c, o, s) => Image.asset(
                    Images.placeholder,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(

                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 9,bottom: 8,top: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        widget
                                            .productList.offers[widget.index].sellers[0].fullName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  /*Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Image.asset("assets/images/map.png"),
                                  ),*/
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                            //SellerModel sellerModel = Provider.of<ChatProvider>(context).uniqueShopList[index].sellerInfo;
                                            //sellerModel.seller.shop = Provider.of<ChatProvider>(context).uniqueShopList[index].shop;
                                            return ChatScreen(
                                                seller: null,
                                                shopId: widget.productList.offers[widget.index].product[0].userId,
                                                shopName: widget.productList.offers[widget.index].sellers[0].fullName,
                                                image: widget.productList.offers[widget.index].sellers[0].image);
                                          }));
                                    },
                                    icon: Image.asset(Images.chat_image, color: color.colortheme, height: Dimensions.ICON_SIZE_DEFAULT),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric( horizontal: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Specification",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:16 ,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 10,right: 10,
                                  top: 2,bottom: 8
                              ),
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.productList.commonDetails.description,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(children: [
                                Container(
                                  margin:
                                  EdgeInsets.symmetric( horizontal: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Delivery In",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "7 Days",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ]),
                            ),

                            Container(
                              margin: EdgeInsets.symmetric( horizontal: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Contact Info",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(top: 1,left: 10,right: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.productList.offers[widget.index].sellers[0].phone,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [HexColor("#E07B7D"), HexColor("#F79294")],
                          ),
                        ),
                        child: ElevatedButton(
                          //#F79294
                          onPressed: () async {
                            Get.to(() =>
                                SellerProductDetail(
                                  widget.productList
                                )
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "Show product listings",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: color.fontWeight500),
                          ),
                        ),
                      ),
                      SizedBox(height: 1,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
