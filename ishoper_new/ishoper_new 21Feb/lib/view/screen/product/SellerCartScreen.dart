import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/CommonModel.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/QunatityModel.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/SellerCartModel.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ServiceProduct.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/splash/splash_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerCartScreen extends StatefulWidget {
  SellerCartScreen({Key key}) : super(key: key);

  @override
  State<SellerCartScreen> createState() => _SellerCartScreenState();
}

class _SellerCartScreenState extends State<SellerCartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewCardApi();
  }

  SharedPreferences pref;
  bool isLoading = false;
  bool isLoadingQu = false;
  SellerCartModel sellerCartModel;
  CommonModel commonModel;
  QunatityModel qunatityModel;
  String key_id = "";
  int TotalAmount = 0;
  int QuantityPrice = 0;

  void viewCardApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    sellerCartModel = await ServiceProduct.viewCard(pref.getString(AppConstants.TOKEN).toString());

    if (sellerCartModel.status == true) {
      for (var i = 0; i < sellerCartModel.data.length; i++) {
        key_id = sellerCartModel.data[i].id.toString();
        QuantityPrice = sellerCartModel.data[i].quantity * sellerCartModel.data[i].price;
        TotalAmount = TotalAmount + QuantityPrice;
      }
      // Fluttertoast.showToast(
      //   msg: sellerCartModel.message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      // );
    } else {
      Fluttertoast.showToast(
        msg: sellerCartModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      isLoading = true;
    });
  }

  void deleteCardApi(String id) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    commonModel = await ServiceProduct.deleteCard(pref.getString(AppConstants.TOKEN).toString(), id);

    if (commonModel.status == true) {
      viewCardApi();
      TotalAmount = 0;
      Fluttertoast.showToast(
        msg: commonModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: commonModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      isLoading = true;
    });
  }

  void quantityProductApi(String id, String quantity) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoadingQu = false;
    });

    qunatityModel = await ServiceProduct.updateQuantityCart(pref.getString(AppConstants.TOKEN).toString(), id, quantity);

    if (qunatityModel.status == true) {
      viewCardApi();
      Fluttertoast.showToast(
        msg: qunatityModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: qunatityModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    setState(() {
      isLoadingQu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.0),
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
                    child: Card(child: Image.asset("assets/images/backarrow.png"))),
              ),
              Text(
                "My Cart",
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
                      child: sellerCartModel.data.length != null
                          ? ListView.builder(
                              itemCount: sellerCartModel.data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // Get.to(() =>
                                    //     OfferPage(viewProductModel.data[index]));
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: ((context) => OfferPage())));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        // height: 110.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [HexColor("#FFEDEF"), HexColor("#FFFBFC")],
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 120.0,
                                                    height: 110.0,
                                                    margin: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      image: DecorationImage(image: NetworkImage(AppConstants.imageBaseUrl + "/" + sellerCartModel.data[index].images), fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      color.sizedboxheight(10.0),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                sellerCartModel.data[index].name,
                                                                style: TextStyle(color: HexColor("#2C2C2C"), fontSize: 16.0, fontWeight: color.fontWeight400),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 130,
                                                            ),
                                                            Container(
                                                              alignment: Alignment.topRight,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    deleteCardApi(key_id);
                                                                  },
                                                                  child: Image.asset("assets/images/delete1.png"),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      color.sizedboxheight(5.0),
                                                      Container(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Size : " + sellerCartModel.data[index].size.toString(),
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                color: HexColor("#747474"),
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                            color.sizedboxwidth(5.0),
                                                            Text(
                                                              "color : " + sellerCartModel.data[index].color,
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                color: HexColor("#747474"),
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Rs. " + sellerCartModel.data[index].price.toString(),
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(color: color.colortheme, fontSize: 16.0, fontWeight: color.fontWeight700),
                                                            ),
                                                            Container(
                                                              width: 60,
                                                            ),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (sellerCartModel.data[index].quantity > 1) {
                                                                        sellerCartModel.data[index].quantity = sellerCartModel.data[index].quantity - 1;
                                                                        QuantityPrice = sellerCartModel.data[index].price * sellerCartModel.data[index].quantity;
                                                                        TotalAmount = TotalAmount - QuantityPrice;
                                                                      }

                                                                      quantityProductApi(key_id, sellerCartModel.data[index].quantity.toString());
                                                                    },
                                                                    child: Container(
                                                                      child: Icon(
                                                                        Icons.remove_circle,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: 5, right: 5),
                                                                    child: Text(
                                                                      sellerCartModel.data[index].quantity.toString(),
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      sellerCartModel.data[index].quantity = sellerCartModel.data[index].quantity + 1;
                                                                      QuantityPrice = sellerCartModel.data[index].price * sellerCartModel.data[index].quantity;
                                                                      TotalAmount = TotalAmount + QuantityPrice;
                                                                      quantityProductApi(key_id, sellerCartModel.data[index].quantity.toString());
                                                                    },
                                                                    child: Container(
                                                                      child: Icon(
                                                                        Icons.add_circle,
                                                                        color: color.colorthemedark,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  color.sizedboxheight(10.0),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              child: Text(
                                "No Data",
                                style: TextStyle(color: color.colorblack, fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: color.colorthemedark,
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "Total Amount",
                            style: TextStyle(color: color.colorblack, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          child: Text(
                            TotalAmount.toString(),
                            style: TextStyle(color: color.colorblack, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: HexColor("#E07B7D"),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [HexColor("#E07B7D"), HexColor("#F79294")],
                      ),
                    ),
                    child: ElevatedButton(
                      ////#F79294
                      onPressed: () {
                        // addCardApi();
                        // print(widget.productList.offers[0].id);
                        // Get.to(() => SellerCartScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        "Pay Now",
                        style: TextStyle(color: color.colorWhite, fontSize: 16.0, fontWeight: color.fontWeight500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
