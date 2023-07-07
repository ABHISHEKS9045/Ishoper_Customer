import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ColorProductModel.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wallet/wallet_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../localization/language_constrants.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/custom_themes.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import 'TamaraCheckOutScreen.dart';

class TamaraPaymentScreen extends StatefulWidget {
  final customerId;

  TamaraPaymentScreen(this.customerId);

  @override
  State<TamaraPaymentScreen> createState() => _TamaraPaymentScreenState();
}

class _TamaraPaymentScreenState extends State<TamaraPaymentScreen> {
  String restCheckout = "${AppConstants.BASE_URL}api/v1/wallet/add-amount?customer_id=13&amount=300";
  int likeButtonColor = 0;
  double rupey = 100.00;
  double rupey1 = 200.00;
  double rupey2 = 500.00;

// final TextEditingController AmountController = C
  String success = "https://example.com/checkout/success";
  String failure = "https://example.com/checkout/failure";
  String cancel = "https://example.com/checkout/cancel";
  String notification = "https://example.com/payments/tamarapay";

  String lang_ar = "ar_SA";
  String lang_en = "en_US";
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Colors.white,
        title: Text(
         "${getTranslated ('Payment',context).toString()}",
          textAlign: TextAlign.center,
          style: titilliumRegular.copyWith(
            fontSize: 20,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
            // startCheckout( context, widget.customerId.toString(), amountController.text );
            await amountSubmit(context, widget.customerId.toString(), amountController.text);
           Navigator.of(context).pop(
           );
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) {
          //     return TamaraCheckOutScreen(
          //       checkoutUrl: "https://tamara.co/checkout/0a17d40a-6180-4f4b-ba7c-498ae79e30dc?locale=en_US",
          //       successUrl: success,
          //       failUrl: failure,
          //       cancelUrl: cancel,
          //     );
          //   },
          // ));
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFFFE8551),
          ),
          child: Text(
            "${getTranslated('Add Money', context)}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 20, left: 20, top: 30),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             "${ getTranslated('Add Money to Wallet', context)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 30),
              child: CustomTextField(
                maxLine: 2,
                controller: amountController,
                hintText: getTranslated('ENTER Amount',context),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: likeButtonColor == 1 ? Colors.green : Color(0xFFFE8551),),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          likeButtonColor = 1;
                        });
                        amountController.text = rupey.toStringAsFixed(2);
                      },
                      child: Text(
                        "${rupey.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        // color: Color(0xFFFE8551),
                        color: likeButtonColor == 2 ? Colors.green : Color(0xFFFE8551)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          likeButtonColor = 2;
                          amountController.text = rupey1.toStringAsFixed(2);
                        });
                      },
                      child: Text(
                        "${rupey1.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        // color: Color(0xFFFE8551),
                        color: likeButtonColor == 3 ? Colors.green : Color(0xFFFE8551)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          likeButtonColor = 3;
                          amountController.text = rupey2.toStringAsFixed(2);
                        });
                      },
                      child: Text(
                        "${rupey2.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
            // IconButton(
            //     icon: Text(
            //       "100.00",
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            //     ),
            //     // Within the `FirstRoute` widget
            //     onPressed: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(builder: (context) => startCheckout()),
            //       // );
            //     }),
            ),
      ),
    );
  }

  String generateRandomString(int count) {
    final random = Random();
    const allChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-';

    final randomString = List.generate(count, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

   startCheckout(BuildContext context, String customerId, String amount) async {
    var body = {
      "order_reference_id": generateRandomString(26),
      "total_amount": {
        "amount": amount,
        "currency": "SAR",
      },
      "description": "Wallet",
      "country_code": "SA",
      "payment_type": "PAY_BY_INSTALMENTS",
      "instalments": null,
      "locale": lang_ar,
      "items": [
        {
          "reference_id": "123456",
          "type": "Digital",
          "name": "Lego City 8601",
          "sku": "SA-12436",
          "quantity": 1,
          "total_amount": {
            "amount": amount,
            "currency": "SAR",
          }
        }
      ],
      "consumer": {
        "first_name": "Mona",
        "last_name": "Lisa",
        "phone_number": "502223333",
        "email": "user@example.com",
      },
      "shipping_address": {
        "first_name": "Mona",
        "last_name": "Lisa",
        "line1": "3764 Al Urubah Rd",
        "line2": "string",
        "region": "As Sulimaniyah",
        "postal_code": "12345",
        "city": "Riyadh",
        "country_code": "SA",
        "phone_number": "502223333",
      },
      "tax_amount": {
        "amount": "100",
        "currency": "SAR",
      },
      "shipping_amount": {
        "amount": "100",
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
    };

    var header = {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI4NzBlNTllOC1mYTFjLTRjZWEtODI2Ny00YWQyMGFiOGY5M2EiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiZWU4YWEwZWU4YzE4N2Y5OTBhYmVkN2Q2NWQ2ZjIzY2QiLCJpYXQiOjE2ODI5ODE3MjgsImlzcyI6IlRhbWFyYSJ9.wqz-BZfrC5HovN_hY8BAoAj5gvJGIDmdwEbbST63kEq9CoOyEgzwDOvU7C1vAekww8L7AEUb398aYM9-rVsukdbMBHnnwuqLdJvLbEY9NUCwX9ZQfe4PwF79ha1NzaNku0SeLGhgfQY_GTYq-e9kMcJuQ7IFD0UFs32GU1zcozcI4oKOMZlJVpQQPzKC4o_sWmqGFv5GOhok_L-kkGeqgi6X7lkRy7xTG-hkECIPT7E3Ty9VezvTeWF5zNU_9AFDUMldyquFG41gd-Q0WT5ybbJwjcPv3u6NejSInjzr51MiscIy4tXaX-Eej4NYFbk4aMD5lS6phPmblFJQHHRK_Q",
    };

    http.Response response = await http.post(Uri.parse("${AppConstants.BASE_URL}${AppConstants.SUBMIT_AMOUNT}customer_id=$customerId&amount=${amount}"), headers: header, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      /*{
      "order_id": "0a17d40a-6180-4f4b-ba7c-498ae79e30dc",
      "checkout_id": "0a17d40a-6180-4f4b-ba7c-498ae79e30dc",
      "checkout_url": "https://tamara.co/checkout/0a17d40a-6180-4f4b-ba7c-498ae79e30dc?locale=en_US",
      "status": "new"
    }*/
      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return TamaraCheckOutScreen(
              checkoutUrl: data["checkout_url"],
              successUrl: success,
              failUrl: failure,
              cancelUrl: cancel,
            );
          },
        ));
      }
    }
  }

  amountSubmit(BuildContext context, String customerId, String amount) async {
    Dio dio = Dio();
    try {
       var response = await dio.post("${AppConstants.BASE_URL}${AppConstants.SUBMIT_AMOUNT}customer_id=$customerId&amount=${amount}");
      final responseData = json.decode(response.toString());
      print(" responseDataAmount ==========> $responseData");
      if (responseData['status'] == 200) {
        var message = responseData["message"].toString();
        Fluttertoast.showToast(msg: message.toString());
        amountController.clear();
      } else {
        var message = responseData["message"].toString();
        debugPrint(' Error ==========> $message');
        Fluttertoast.showToast(msg: message.toString());
      }
    } catch (e) {
      debugPrint('Error ========>  ${e.toString()}');
    }
  }
}
