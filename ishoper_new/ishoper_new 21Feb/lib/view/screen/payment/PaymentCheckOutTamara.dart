import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tamara_sdk/tamara_sdk.dart';
import '../dashboard/dashboard_screen.dart';

class PaymentCheckOutTamara extends StatefulWidget {
  final checkoutUrl;
  final successUrl;
  final failUrl;
  final cancelUrl;
  final UserId;
  final String OrderId;

  const PaymentCheckOutTamara({this.checkoutUrl, this.successUrl, this.failUrl, this.cancelUrl, this.UserId, this.OrderId});

  @override
  State<PaymentCheckOutTamara> createState() => _PaymentCheckOutTamaraState();
}

class _PaymentCheckOutTamaraState extends State<PaymentCheckOutTamara> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TamaraCheckout(
        widget.checkoutUrl,
        widget.successUrl,
        widget.failUrl,
        widget.cancelUrl,
        onPaymentSuccess: () {
          successUrltamara(
            context,
          );
          Fluttertoast.showToast(msg: getTranslated("Your payment has been processed successfully", context));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);

          // todo: redirect to home page
        },
        onPaymentFailed: () {
          faildUrltamara(
            context,
          );
          Fluttertoast.showToast(msg: getTranslated("Payment failed due to technical issue.", context));
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onPaymentCanceled: () {
          faildUrltamara(
            context,
          );
          Fluttertoast.showToast(msg: getTranslated("You canceled payment process.", context));
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  successUrltamara(
    context
  ) async {
    Dio dio = Dio();

    var response;
    response = await dio.get("https://ishopper.sa/api/v1/tamara-checkout-complete?paymentStatus=approved&orderId=${widget.OrderId}&userId=${widget.UserId}");

    final responseData = json.decode(response.toString());
    print("responseDataTamaraSuccesss============>$responseData");
  }

  faildUrltamara(
    context
  ) async {
    Dio dio = Dio();

    var response;
    response = await dio.get("https://ishopper.sa/api/v1/tamara-checkout-complete?paymentStatus=declined&orderId=${widget.OrderId}&userId=${widget.UserId}");

    final responseData = json.decode(response.toString());
    print("responseData Tamara faildUrltamara============>$responseData");
  }
}
