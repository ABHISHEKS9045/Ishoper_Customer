import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/ViewProductDetailModel.dart';

class YourProductDetails extends StatefulWidget {

  final String name;
  final String image;
  final String color;
  final String size;
  final String description;
  final List images;

  // Datum productList;
  // int index;
  YourProductDetails(
      // this.productList,
      // this.index ,

      {Key key, this.name, this.image, this.images,this.color,this.size,this.description}) : super(key: key
  );

  @override
  State<YourProductDetails> createState() => _YourProductDetailsState();
}

class _YourProductDetailsState extends State<YourProductDetails> {
  ColorResources color = ColorResources();
  String imageBaseUrl =
      "http://ishopper.sa/storage/app/public/custom/product/";

  final PageController _controller = PageController();


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
          Text('Your Product',
              style: robotoRegular.copyWith(
                  fontSize: 20, color: Theme.of(context).cardColor)),
        ]),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : color.colortheme,
      ),
      body: Column(
        children: [
          InkWell(
            child: widget.images != null
                ? Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[
                      Provider.of<ThemeProvider>(context).darkTheme
                          ? 700
                          : 300],
                      spreadRadius: 1,
                      blurRadius: 5)
                ],
                gradient: Provider.of<ThemeProvider>(context).darkTheme
                    ? null
                    : LinearGradient(
                  colors: [
                    ColorResources.WHITE,
                    ColorResources.IMAGE_BG
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(children: [
              SizedBox(
              height: MediaQuery.of(context).size.width,
              child: widget.images.length != null
                  ? PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: Images.placeholder,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    image: imageBaseUrl + '/'+ widget.images[index],
                    imageErrorBuilder: (c, o, s) => Image.asset(
                      Images.placeholder,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                onPageChanged: (index) {
                  Provider.of<ProductDetailsProvider>(context,
                      listen: false)
                      .setImageSliderSelectedIndex(index);
                },
              )
                  : SizedBox(),
            ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _indicators(context),
                      ),
                      Spacer(),
                      Provider.of<ProductDetailsProvider>(context)
                          .imageSliderIndex !=
                          null
                          ? Padding(
                        padding: const EdgeInsets.only(
                            right: Dimensions.PADDING_SIZE_DEFAULT,
                            bottom: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Text(
                            '${Provider.of<ProductDetailsProvider>(context).imageSliderIndex + 1}' +
                                '/' +
                                '${widget.images.length.toString()}'),
                      )
                          : SizedBox(),
                    ],
                  ),
                ),

                SizedBox.shrink(),
              ]),
            )
                : SizedBox(),
          ),

          /*Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3

              ),
              itemCount: widget.images.length,
              itemBuilder: (context,index) {
                return Container(
                  child:FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: Images.placeholder,
                                    height: MediaQuery.of(context).size.width,
                                    width: MediaQuery.of(context).size.width,
                                    image: imageBaseUrl + '/'+ widget.images[index],

                                    // 'imageBaseUrl/${widget.images[index][0]

                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholder,
                                      height: MediaQuery.of(context).size.width,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),


                  ),
                );
              }
            ),
          ),*/
          Container(
            height: 34.h,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 9,bottom: 8,top: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.name,
                              // widget
                              //     .productList.offers[widget.index].sellers[0].fullName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          // child: Image.asset("assets/images/map.png"),
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
                        fontSize:17 ,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h,),
                  Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: Text(
                      "Color : " +
                          widget.color,

                      style: TextStyle(
                        color: HexColor("#747474"),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: Text(
                      "Size : " +
                          widget.size,

                      style: TextStyle(
                        color: HexColor("#747474"),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h,),
                  Container(
                    margin:
                    EdgeInsets.only(left: 10,right: 10,
                        top: 2,bottom: 8
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description',
                      // widget.productList.commonDetails.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: Text(

                      widget.description,

                      style: TextStyle(
                        color: HexColor("#747474"),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h,),
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
                      '',

                      // widget.productList.offers[widget.index].sellers[0].phone,
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
          ),
        ],
      ),
    );
  }
  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < widget.images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index ==
            Provider.of<ProductDetailsProvider>(context).imageSliderIndex
            ? color.colortheme
            : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: 10,
      ));
    }
    return indicators;
  }
}
