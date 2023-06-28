import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/customproduct/CustomService.dart';
import 'package:sixvalley_vendor_app/customproduct/product_image_view.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sizer/sizer.dart';

import '../provider/chat_provider.dart';
import '../utill/styles.dart';
import '../view/base/custom_button.dart';
import '../view/screens/chat/chat_screen.dart';
import 'CustomProductModel.dart';
import 'ProductDetailModel.dart';

class CustomProductDetail extends StatefulWidget {
  Datum customProductDetail;

  CustomProductDetail(this.customProductDetail);

  State<CustomProductDetail> createState() => _CustomProductDetail();
}

class _CustomProductDetail extends State<CustomProductDetail> {
  TextEditingController searchController = new TextEditingController();
  ColorResources color = ColorResources();

  SharedPreferences pref;
  bool isLoading = false;
  ProductDetailModel productDetailModel;
  List<OfferProductModel> searchProductList = [];

  void customProductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    productDetailModel = await CustomService.customProductDetail(pref.getString(AppConstants.TOKEN).toString(), widget.customProductDetail.id.toString());

    if (productDetailModel.status == 200) {
      // for(final i = 0; i< productDetailModel.data),
      print("successfully");
    } else {
      print("error product");
    }

    setState(() {
      isLoading = false;
    });
  }

  // ScrollController listScrollController = ScrollController();

  void showMyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
              itemCount: searchProductList.length,
              itemBuilder: (_, i) {
                OfferProductModel model = searchProductList[i];
                return Container(
                  height: 25.w,
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: CachedNetworkImage(
                              height: 15.w,
                              width: 15.w,
                              fit: BoxFit.cover,
                              placeholder: (ctx, url) => Image.asset(
                                    Images.placeholder_image,
                                  ),
                              errorWidget: (ctx, url, err) => Image.asset(
                                    Images.placeholder_image,
                                  ),
                              // imageUrl: 'https://mactosys.com/iShoper/storage/app/public/custom/product/2022-12-23-63a587adbe704airbnb4.jpg'
                              imageUrl: 'http://ishopper.sa/storage/app/public/product/' + model.imgURL),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        SizedBox(
                            width: 30.w,
                            child: Text(
                              model.name,
                              maxLines: 1,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '₹ ' + model.price,
                          style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomButton(
                            btnTxt: 'OFFER',
                            backgroundColor: ColorResources.WHITE,
                            onTap: () async {
                              Navigator.pop(context);
                              await offerProductToCustomer(widget.customProductDetail.id.toString(), model.price, model.name, model.id);

                              // showMyBottomSheet(context);
                            })
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isLoading
            ? Padding(
                padding: EdgeInsets.only(top: 45.h, left: 50.w),
                child: CircularProgressIndicator(color: color.colortheme),
              )
            : Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ProductImageView(images: widget.customProductDetail.images, isForCustomProduct: true),
                        /*Container(
                    child: widget.customProductDetail.images.length !=0 ?
                    FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: Images.placeholder_image,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      image: imageBaseUrl +
                          '/' +
                          widget.customProductDetail.images[0],
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder_image,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ) : SizedBox(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(Images.placeholder_image,fit: BoxFit.cover,)
                    ),
                  ),*/
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              color.sizedboxwidth(20.0),
                              Padding(
                                padding: const EdgeInsets.only(right: 70.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 2))],
                                    ),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Product Details",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: "Inter", fontSize: 24.0, color: color.textColor, fontWeight: color.fontWeight600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Custom Product Details",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  var chatModel = Provider.of<ChatProvider>(context, listen: false);
                                  await chatModel.initChatList(context);

                                  int index = 0;
                                  bool isFound = false;
                                  for (int i = 0; i < chatModel.customerList.length; i++) {
                                    if (chatModel.customerList[i].id == widget.customProductDetail.customer.id) {
                                      index = i;
                                      isFound = true;
                                      break;
                                    }
                                  }

                                  if (isFound) {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return ChatScreen(customer: chatModel.customerList[index], customerIndex: index, messages: chatModel.customersMessages[index]);
                                    }));
                                  } else {
                                    await chatModel.loadChatForSeller(widget.customProductDetail.customer.id);
                                    // chatModel.setCustomerMessage([]);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return ChatScreen(customer: widget.customProductDetail.customer, messages: chatModel.chatList);
                                    }));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.chat,
                                    color: color.colortheme,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Customer Name - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.name,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Phone Number - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.customer.phone,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Product Category - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.categoryId,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Product Size - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.size ??= '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Product Material - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.material ??= '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Product Color - ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (widget.customProductDetail.color.isNotEmpty)
                                  Container(
                                    child: Text(
                                      widget.customProductDetail.color[0],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Product Description ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.customProductDetail.description ??= '',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 50,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 2))],
                                ),
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    filled: false,
                                    /*suffixIcon: Icon(
                                Icons.search,
                                color: color.colorthemedark,
                              ),*/
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular((15.0)), borderSide: BorderSide(color: Colors.white, width: 5.0)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular((15.0))),
                                    focusColor: color.colortheme,
                                    hoverColor: color.colorthemedark,
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: color.colortheme,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  onSubmitted: (text) async {
                                    await loadSearchProducts(searchController.text);
                                    showMyBottomSheet(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              CustomButton(
                                  btnTxt: 'SEARCH',
                                  backgroundColor: ColorResources.WHITE,
                                  onTap: () async {
                                    await loadSearchProducts(searchController.text);
                                    showMyBottomSheet(context);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void loadSearchProducts(String searchKey) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    searchProductList = await CustomService.searchOfferProduct(pref.getString(AppConstants.TOKEN).toString(), searchKey);

    print(searchProductList.length);
    setState(() {
      isLoading = false;
    });
  }

  void offerProductToCustomer(String customProductId, String price, String name, String sellerProductId) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    bool isSuccess = await CustomService.updateOfferProduct(pref.getString(AppConstants.TOKEN).toString(), customProductId, price, name, widget.customProductDetail.description, sellerProductId);

    setState(() {
      isLoading = false;
    });
    if (isSuccess) showCustomSnackBar('Product Updated..', context);
  }
}
