import 'package:flutter/material.dart';
import 'package:tamara_sdk/tamara_sdk.dart';

class TamaraCheckOutScreen extends StatefulWidget {

  final String checkoutUrl;
  final String successUrl;
  final String failUrl;
  final String cancelUrl;
  const TamaraCheckOutScreen({ this.checkoutUrl, this.successUrl, this.failUrl, this.cancelUrl});

   // TamaraCheckOutScreen({ required this.checkoutUrl, required this.successUrl, required this.failUrl, required this.cancelUrl});

  @override
  State<TamaraCheckOutScreen> createState() => _TamaraCheckOutScreenState();
}

class _TamaraCheckOutScreenState extends State<TamaraCheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
          child: TamaraCheckout(
            widget.checkoutUrl,
            widget.successUrl,
            widget.failUrl,
            widget.cancelUrl,
            onPaymentSuccess: () {

            },
            onPaymentFailed: () {

            },
            onPaymentCanceled: () {

            },
          )
      ),
    );
  }
}
