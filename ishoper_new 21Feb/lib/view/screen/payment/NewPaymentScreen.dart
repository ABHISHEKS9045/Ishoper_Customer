import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_loader.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/PaymentCheckOutTamara.dart';
import 'package:http/http.dart' as http;
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
    this.amount, this.tax, this.shippingFees,
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

  String lang_ar = "ar";
  String lang_en = "en";

  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  ProfileProvider model;
  LanguageModel languageName;


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
    if(mounted) {
      getUserInfo(context);
    }
    debugPrint("$TAG widget customerDetails ===========> ${widget.customerDetails}");
    debugPrint("$TAG widget Product ===========> ${widget.Product}");
    debugPrint("$TAG widget amount ===========> ${widget.amount}");


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
          Expanded(
            child: _isLoading ? Center(
              child: CustomLoader(color: Theme.of(context).primaryColor),
            ) : Stack(
              children: [
                InkWell(
                    onTap: () async {
                      debugPrint("$TAG checkout clicked");
                      await startCheckout(context);
                    },
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        Images.tamara,
                      ),
                    ),),
                // _isLoading
                //     ? Center(
                //         child: CustomLoader(color: Theme.of(context).primaryColor),
                //       )
                //     : SizedBox.shrink(),
              ],
            ),
          ),
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
