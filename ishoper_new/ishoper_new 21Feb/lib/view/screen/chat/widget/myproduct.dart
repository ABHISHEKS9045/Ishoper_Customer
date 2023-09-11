// ignore_for_file: prefer_const_constructors, duplicate_ignore
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/offerpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/model/ViewProductModel.dart';
import '../../../../provider/ServiceProduct.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/no_internet_screen.dart';

class MyProductPage extends StatefulWidget {
  MyProductPage({Key key}) : super(key: key);

  @override
  State<MyProductPage> createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  @override
  void initState() {
    super.initState();
    viewProductApi();
  }

  ViewProductModel viewProductModel;
  SharedPreferences pref;
  bool isLoading = false;
  String colorName = "";
  bool textNull = false;

  void viewProductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    viewProductModel = await ServiceProduct().viewProduct(pref.getString(AppConstants.TOKEN).toString());

    if (viewProductModel.status == 200) {
      for (var i = 0; i < viewProductModel.data.length; i++) {
        if (viewProductModel.data[i].color == null)
          colorName = "";
        else {
          for (var j = 0; j < viewProductModel.data[i].color.length; j++) {
            if (viewProductModel.data[i].color == []) {
              colorName = "";
            } else {
              colorName = viewProductModel.data[i].color[j].name.toString();
            }
          }
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: viewProductModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My Products",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Inter", fontSize: 24.0, color: color.textColor, fontWeight: color.fontWeight600),
              ),
            ],
          ),
          color.sizedboxheight(10.0),
          Expanded(
            child: isLoading
                ? Container(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: viewProductModel.data.length == 0
                          ? NoInternetOrDataScreen(isNoInternet: false)
                          : ListView.builder(
                              itemCount: viewProductModel.data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(() => OfferPage(viewProductModel.data[index]));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(left: 15),
                                        // height: 110.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [HexColor("#FFBE81").withOpacity(0.35), HexColor("#FFBE81").withOpacity(0.35)],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 1.h),
                                              width: 25.w,
                                              height: 25.w,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: viewProductModel.data[index].images != null && viewProductModel.data[index].images.length != 0
                                                    ? CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: AppConstants.imageBaseUrl + '/' + viewProductModel.data[index].images[0],
                                                      )
                                                    : Image.asset(
                                                        Images.placeholder,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 52.w,
                                                      child: Text(
                                                        viewProductModel.data[index].name,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: HexColor("#2C2C2C"),
                                                          fontSize: 19.0,
                                                          fontWeight: color.fontWeight500,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        deleteCustomProduct(viewProductModel.data[index].id);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(top: 5),
                                                        child: Icon(
                                                          CupertinoIcons.delete,
                                                          size: 24,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                color.sizedboxheight(5.0),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Size :${viewProductModel.data[index].size} ",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: color.colorblack,
                                                        //fontSize: 16.0,
                                                      ),
                                                    ),
                                                    color.sizedboxwidth(5.0),
                                                    if (viewProductModel.data[index].color.isNotEmpty)
                                                      Text(
                                                        "color : ${viewProductModel.data[index].color.first.name} ",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: color.colorblack,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Text(
                                                  viewProductModel.data[index].availableOffers.toString() + " Offers",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: color.colortheme,
                                                    fontSize: 18.0,
                                                    fontWeight: color.fontWeight700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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

  deleteCustomProduct(int id) async {
    bool isSuccess = await ServiceProduct().deleteProduct(pref.getString(AppConstants.TOKEN).toString(), id.toString());

    if (isSuccess) {
      Fluttertoast.showToast(msg: 'Product removed successfully..');
      await viewProductApi();
    } else
      Fluttertoast.showToast(msg: 'Something went wrong');
  }
}

// ignore_for_file: prefer_const_constructors

ColorResources color = ColorResources();

Widget productTextField() {
  return TextField(
    decoration: InputDecoration(
      filled: false,
      suffixIcon: Image.asset("assets/images/search.png"),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: Colors.white, width: 5.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular((20.0)),
      ),
      focusColor: color.colortheme,
      hoverColor: color.colorthemedark,
      hintText: "Search",
      hintStyle: TextStyle(
        color: color.colortheme,
        fontSize: 16.0,
      ),
    ),
  );
}
