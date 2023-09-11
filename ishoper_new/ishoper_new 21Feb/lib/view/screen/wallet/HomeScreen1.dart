import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:hypersdkflutter/hypersdkflutter.dart';


class HomeScreen1 extends StatefulWidget {
  // final hyperSDK = HyperSDK();
  //  HomeScreen1( {HyperSDK hyperSDK});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}
void hyperSDKCallbackHandler(MethodCall methodCall) {
  switch (methodCall.method) {
    case "hide_loader":
      break;
    case "process_result":
      var args = {};

      try {
        args = json.decode(methodCall.arguments);
      } catch (e) {
        print(e);
      }

      var error = args["error"] ?? false;

      var innerPayload = args["payload"] ?? {};

      var status = innerPayload["status"] ?? " ";
      var pi = innerPayload["paymentInstrument"] ?? " ";
      var pig = innerPayload["paymentInstrumentGroup"] ?? " ";

      if (!error) {
        switch (status) {
          case "charged":
            {
              // Successful Transaction
              // check order status via S2S API
            }
            break;
          case "cod_initiated":
            {
              // User opted for cash on delivery option displayed on payment page
            }
            break;
        }
      } else {
        var errorCode = args["errorCode"] ?? " ";
        var errorMessage = args["errorMessage"] ?? " ";
        switch (status) {
          case "backpressed":
            {
              // user back-pressed from PP without initiating any txn
            }
            break;
          case "user_aborted":
            {
              // user initiated a txn and pressed back
              // check order status via S2S API
            }
            break;
          case "pending_vbv":
            {}
            break;
          case "authorizing":
            {
              // txn in pending state
              // check order status via S2S API
            }
            break;
          case "authorization_failed":
            {}
            break;
          case "authentication_failed":
            {}
            break;
          case "api_failure":
            {
              // txn failed
              // check order status via S2S API
            }
            break;
          case "new":
            {
              // order created but txn failed
              // check order status via S2S API
            }
            break;
        }
      }
  }
}
class _HomeScreen1State extends State<HomeScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.yellow,),
    );
  }
}
