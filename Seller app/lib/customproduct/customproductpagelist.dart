import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources2.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sizer/sizer.dart';

import '../utill/images.dart';
import 'CustomProductDetail.dart';
import 'CustomProductModel.dart';
import 'CustomService.dart';

class CustomProductListScreen extends StatefulWidget {
  const CustomProductListScreen({Key key}) : super(key: key);

  @override
  State<CustomProductListScreen> createState() => _CustomProductListScreenState();
}

class _CustomProductListScreenState extends State<CustomProductListScreen> {
  ColorResources color = ColorResources();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customProductApi();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   final custom =
    //       Provider.of<CustomProductlistModel>(context, listen: false);
    //   custom.customproductlist();
    // });
  }

  SharedPreferences pref;
  bool isLoading = false;
  CustomProductModel customProductModel;

  void customProductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    customProductModel = await CustomService.customProduct(pref.getString(AppConstants.TOKEN).toString());

    if (customProductModel.status == 200) {
      print("successfully");
    } else {
      print("error product");
    }

    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.colorWhite,
        centerTitle: true,
        title: Text(
          "Custom Product",
          style: TextStyle(color: color.colorblack),
        ),
      ),
      body: isLoading
          ? Container(
              child: customProductModel.data.isNotEmpty
                  ? ListView.builder(
                      itemCount: customProductModel.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomProductDetail(customProductModel.data[index])));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey, offset: Offset(1, 2))],
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(vertical: 1.h),
                                            width: 22.w,
                                            height: 22.w,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: customProductModel.data[index].images.length != 0
                                                  ? CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: AppConstants.imageBaseUrl + '/' + customProductModel.data[index].images[0],
                                                    )
                                                  : Image.asset(
                                                      Images.placeholder_image,
                                                      fit: BoxFit.cover,
                                                    ),
                                            )),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        /*if(customProductModel.data[index].images!=null)
                                    Container(
                                    height: 50,
                                    width: 50,
                                    child:
                                      Image.network(
                                      imageBaseUrl +
                                          '/' +
                                          customProductModel.data[index].images,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),*/
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 53.w,
                                                      child: Text(
                                                        customProductModel.data[index].name,
                                                        maxLines: 1,
                                                        style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                    /*InkWell(
                                                onTap: (){
                                                  removeCustomProductApi(customProductModel.data[index].id.toString());
                                                },
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Icon(Icons.delete,color: color.colortheme,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),*/
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 0.5.h,
                                                ),
                                                Text(
                                                  "Category: " + customProductModel.data[index].categoryName.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 0.5.h,
                                                ),
                                                Text(
                                                  customProductModel.data[index].availableOffers.toString() + " Offers",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(color: color.colortheme, fontSize: 18.0, fontWeight: color.fontWeight700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    )
                  : Center(
                      child: Text(
                      "No Data found!",
                      style: TextStyle(fontSize: 20, color: Colors.orange),
                    )),
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: color.colortheme,
              ),
            ),
    );
  }

  void removeCustomProductApi(String id) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    bool isSuccess = await CustomService.removeCustomProduct(pref.getString(AppConstants.TOKEN).toString(), id);

    if (isSuccess) {
      showCustomSnackBar('Product Removed..', context);
    }
    await customProductApi();

    setState(() {
      isLoading = true;
    });
  }
}
