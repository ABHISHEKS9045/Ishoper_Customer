import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_loader.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/PaymentCheckOutTamara.dart';
import 'package:http/http.dart' as http;
import 'package:hyperpay_plugin/flutter_hyperpay.dart';
import 'package:hyperpay_plugin/model/ready_ui.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/language_model.dart';
import '../../../provider/cart_provider.dart';
import '../../../utill/images.dart';

class NewPaymentScreen extends StatefulWidget {
  final Product;
  final amount;
  final customerDetails;
  final double tax;
  final double shippingFees;

  NewPaymentScreen({
    this.Product,
    this.customerDetails,
    this.amount,
    this.tax,
    this.shippingFees,
  });

  @override
  _NewPaymentScreenState createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  static const String TAG = "_NewPaymentScreenState";

  String restCheckout = "https://api-sandbox.tamara.co/checkout";
  String success = "https://example.com/checkout/success";
  String failure = "https://example.com/checkout/failure";
  String cancel = "https://example.com/checkout/cancel";
  String notification = "https://example.com/payments/tamarapay";
  var userId;

  String lang_ar = "ar";
  String lang_en = "en";

  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  ProfileProvider model;
  LanguageModel languageName;

  final TextEditingController amountController = TextEditingController();

  payRequestNowReadyUI(
      List<String> brandsName,  String checkoutId,  amount) async {
    PaymentResultData paymentResultData;
    paymentResultData = await flutterHyperPay.readyUICards(
      readyUI: ReadyUI(
          brandsName: brandsName,
          checkoutId: checkoutId,
          merchantIdApplePayIOS: InAppPaymentSetting.merchantId,
          countryCodeApplePayIOS: InAppPaymentSetting.countryCode,
          companyNameApplePayIOS: "Test Co",
          themColorHexIOS: '#FFBE81',// FOR IOS ONLY
          setStorePaymentDetailsMode: true
      ),
    );

    if (paymentResultData.paymentResult == PaymentResult.success || paymentResultData.paymentResult == PaymentResult.sync) {



     // amountSubmit(context,widget.customerId,'',checkoutId);


    }
  }

  FlutterHyperPay flutterHyperPay ;

  hyperPayUi(){
    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
      paymentMode:  PaymentMode.test,
      lang: InAppPaymentSetting.getLang(),
    );
  }

  Future<String> request() async {

    String paymentAmount = amountController.text.trim();
    var url = "https://test.oppwa.com/v1/checkouts";
    var dio = Dio();

    dio.options.headers["Authorization"] =
    "Bearer OGFjN2E0Y2E4OTk0NDUyMDAxODk5NjY5NDIyYjAzMDd8V1puOXB3UmhHUQ";
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";

    var data = {
      "entityId": "8ac7a4ca89944520018996851f110382",
      "amount": paymentAmount,
      "currency": "SAR",
      "paymentType": "DB",
    };


    try {
      var response = await dio.post(url, data: data);
      final responseData = jsonDecode(response.toString());

      if (response.statusCode >= 400) {
        return response.data.toString();
      } else {
        return responseData["id"];
      }
    } catch (e) {
      return "Error: $e";
    }

  }


  getUserInfo(BuildContext context) async {
    _isLoading = true;
    setState(() {});
    model = Provider.of<ProfileProvider>(context, listen: false);
    await model.getUserInfo(context);
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    hyperPayUi();
    if (mounted) {
      getUserInfo(context);
      // successUrltamara(context,);
    }

    debugPrint("$TAG widget Product ===========> ${widget.Product}");
    debugPrint("$TAG widget amount ===========> ${widget.amount}");
    userId = widget.customerDetails['customer_id'];
    debugPrint("$TAG widget customerDetailsuserId ===========> ${userId}");

    num finalAmount = num.parse(widget.amount.toStringAsFixed(2));
    debugPrint("$TAG finalAmount ===========> $finalAmount");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: getTranslated('PAYMENT', context),
          ),
          SizedBox(height: 100,),
          Center(child: _isLoading
              ? Center(
            child: CustomLoader(color: Theme.of(context).primaryColor),
          )
              : Center(child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              InkWell(
                onTap: () async {
                  debugPrint("$TAG checkout clicked");
                  await startCheckout(context);
                },
                child: Container(

                  margin: EdgeInsets.only(left: 20,right: 20),
                  height: 160,
                  width :MediaQuery.of(context).size.width,

                  child: Image.asset(
                    Images.tamara,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  print("payment================>${amountController.text}");
                  String checkoutId = "";
                  // checkoutId = await requestCheckoutId();
                  checkoutId =  await request();

                  if (checkoutId != null) {
                    print(checkoutId);
                    // Retrieve the payment amount from the text field
                    String paymentAmount = amountController.text.trim();
                    if (paymentAmount.isNotEmpty) {
                      double amount = double.parse(paymentAmount);
                      // Call the payment method with the entered payment amount
                      try{
                        payRequestNowReadyUI(
                          ["VISA"],
                          checkoutId,
                          amount,
                        );

                      }
                      catch (e){
                        print("payRequestNowReadyUI ${e.toString()}");

                      }

                    } else {
                      // Show an error message or handle the case when the payment amount is not entered.
                    }
                  }

                },
                child: Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 20),
                  padding: EdgeInsets.all(15),
                  height: 150,
                  width :MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(15),),

                    child: Image.asset(
                      Images.hyperpay,
                    
                  ),
                ),
              ),
            ],
          ),),)

        ],
      ),
    );
  }

  String generateRandomString(int count) {
    final random = Random();
    const allChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-';
    final randomString = List.generate(count, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  Future<void> startCheckout(BuildContext context) async {
    _isLoading = true;
    setState(() {});
    var data = jsonEncode({
      "order_reference_id": generateRandomString(26),
      "total_amount": {
        "amount": widget.amount.toStringAsFixed(2),
        "currency": "SAR",
      },
      "description": widget.Product['name'], // product name
      "country_code": "SA",
      "payment_type": "PAY_BY_INSTALMENTS",
      "instalments": null,
      "locale": lang_ar,
      "items": [
        {
          "reference_id": widget.Product['product_id'], // product id
          "type": "Digital",
          "name": widget.Product['name'], // product name
          "sku": widget.Product['product_id'], // sku or product id
          "quantity": Provider.of<CartProvider>(context, listen: false).cartList[0].quantity.toString(), // actual quantity
          "total_amount": {
            "amount": widget.Product['product_id'], // total payable
            "currency": "SAR",
          }
        }
      ],
      "consumer": {
        "first_name": model.userInfoModel.fName, // first name
        "last_name": model.userInfoModel.lName, // last name
        "phone_number": model.userInfoModel.phone, // phone number
        "email": model.userInfoModel.email, // email address
      },
      "shipping_address": {
        "first_name": model.userInfoModel.fName, // first name
        "last_name": model.userInfoModel.lName, // last name
        "phone_number": model.userInfoModel.phone, // phone number
        "line1": widget.customerDetails['address_type'], // address line 1
        "line2": widget.customerDetails['address_type'], // (optional) address line 2
        "region": widget.customerDetails['state'], // reagion  or state
        "postal_code": widget.customerDetails['zip'], // postal code or pin code zip code
        "city": widget.customerDetails['city'], // city name
        "country_code": "SA",
      },
      "tax_amount": {
        "amount": widget.tax.toStringAsFixed(2), // tax amount
        "currency": "SAR",
      },
      "shipping_amount": {
        "amount": widget.shippingFees.toStringAsFixed(2), //  shipping fees
        "currency": "SAR",
      },
      "merchant_url": {
        "success": success,
        "failure": failure,
        "cancel": cancel,
        "notification": notification,
      },
      "platform": "Flutter",
      "is_mobile": true,
    });

    var header = {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI4NzBlNTllOC1mYTFjLTRjZWEtODI2Ny00YWQyMGFiOGY5M2EiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiZWU4YWEwZWU4YzE4N2Y5OTBhYmVkN2Q2NWQ2ZjIzY2QiLCJpYXQiOjE2ODI5ODE3MjgsImlzcyI6IlRhbWFyYSJ9.wqz-BZfrC5HovN_hY8BAoAj5gvJGIDmdwEbbST63kEq9CoOyEgzwDOvU7C1vAekww8L7AEUb398aYM9-rVsukdbMBHnnwuqLdJvLbEY9NUCwX9ZQfe4PwF79ha1NzaNku0SeLGhgfQY_GTYq-e9kMcJuQ7IFD0UFs32GU1zcozcI4oKOMZlJVpQQPzKC4o_sWmqGFv5GOhok_L-kkGeqgi6X7lkRy7xTG-hkECIPT7E3Ty9VezvTeWF5zNU_9AFDUMldyquFG41gd-Q0WT5ybbJwjcPv3u6NejSInjzr51MiscIy4tXaX-Eej4NYFbk4aMD5lS6phPmblFJQHHRK_Q",
    };

    debugPrint("$TAG request URL =================> $restCheckout");
    debugPrint("$TAG request headers =================> $header");
    debugPrint("$TAG request data =================> $data");

    http.Response response = await http.post(Uri.parse(restCheckout), headers: header, body: data);

    debugPrint("$TAG response =================> $response");
    debugPrint("$TAG response body =================> ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _isLoading = false;
      setState(() {});
      /*{
      "order_id": "0a17d40a-6180-4f4b-ba7c-498ae79e30dc",
      "checkout_id": "0a17d40a-6180-4f4b-ba7c-498ae79e30dc",
      "checkout_url": "https://tamara.co/checkout/0a17d40a-6180-4f4b-ba7c-498ae79e30dc?locale=en_US",
      "status": "new"
    }*/
      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return PaymentCheckOutTamara(
              checkoutUrl: data["checkout_url"],
              successUrl: success,
              failUrl: failure,
              cancelUrl: cancel,
              UserId: userId,
              OrderId: generateRandomString(26),
            );
          },
        ));
      }
    } else {
      _isLoading = false;
      setState(() {});
    }
  }
}


class InAppPaymentSetting {
  static const String shopperResultUrl= "com.testpayment.payment";
  static const String merchantId = "MerchantId";
  static const String countryCode="SA";
  static getLang() {
    if (Platform.isIOS) {
      return  "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}
