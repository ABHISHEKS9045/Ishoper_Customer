import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/transaction_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/wallet_transaction_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletTransactionProvider extends ChangeNotifier {
  static const String TAG = "WalletTransactionProvider";

  final WalletTransactionRepo transactionRepo;
  bool _isLoading = false;
  bool _firstLoading = false;
  bool _isConvert = false;
  double amount = 0;
  String token;

  bool get isConvert => _isConvert;

  bool get isLoading => _isLoading;

  bool get firstLoading => _firstLoading;
  int _transactionPageSize;

  int get transactionPageSize => _transactionPageSize;
  TransactionModel _walletBalance;

  TransactionModel get walletBalance => _walletBalance;

  int _loyaltyPointPageSize;

  int get loyaltyPointPageSize => _loyaltyPointPageSize;

  WalletTransactionProvider({@required this.transactionRepo});

  List<WalletTransactioList> _transactionList;

  List<WalletTransactioList> get transactionList => _transactionList;

  List<LoyaltyPointList> _loyaltyPointList;
  List<dynamic> walletList = [];

  List<LoyaltyPointList> get loyaltyPointList => _loyaltyPointList;
  bool _is_loding = false;
  bool get is_loding => _is_loding;
  showLoader() {
    _is_loding = true;
    notifyListeners();
  }

  hideLoader() {
    _is_loding = false;
    notifyListeners();
  }

  Future<void> getTransactionList(BuildContext context, int offset) async {
    ApiResponse apiResponse = await transactionRepo.getWalletTransactionList(offset);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _walletBalance = TransactionModel.fromJson(apiResponse.response.data);
      _transactionList = [];
      _transactionList.addAll(TransactionModel.fromJson(apiResponse.response.data).walletTransactioList);
      _transactionPageSize = TransactionModel.fromJson(apiResponse.response.data).totalWalletTransactio;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getLoyaltyPointList(BuildContext context, int offset) async {
    ApiResponse apiResponse = await transactionRepo.getLoyaltyPointList(offset);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      debugPrint("$TAG responseDatatokendattaaaaaaa =========> ${apiResponse.response}");
      _loyaltyPointList = [];
      _loyaltyPointList.addAll(LoyaltyPointModel.fromJson(apiResponse.response.data).loyaltyPointList);
      _loyaltyPointPageSize = LoyaltyPointModel.fromJson(apiResponse.response.data).totalLoyaltyPoint;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future convertPointToCurrency(BuildContext context, int point) async {
    _isConvert = true;
    notifyListeners();
    ApiResponse apiResponse = await transactionRepo.convertPointToCurrency(point);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _isConvert = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('${getTranslated('point_converted_successfully', context)}'),
      ));
    } else {
      _isConvert = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('${getTranslated('point_converted_failed', context)}'),
      ));
    }
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  getWalletAmount(var customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String Token = (prefs.getString('token')).toString();
    print("Token data>>>>>>>>>>>>>>>>>>>>>>>>>>>$Token");
    showLoader();
    Dio dio = Dio();
    try {
      var response = await dio.get('${AppConstants.BASE_URL}api/v1/wallet?customer_id=$customerId');
      final responseData = json.decode(response.toString());
      // debugPrint("$TAG responseDatatokendattaaaaaaa =========> $responseData");

      if (responseData != null) {
        if (responseData["totalBalance"] != null) {
          amount = double.parse(responseData["totalBalance"].toString());
        } else {
          amount = 0;
        }
        if (responseData["CustomerWalletHistory"] != null) {
          hideLoader();
          walletList.clear();
          walletList = responseData["CustomerWalletHistory"];
        } else {
          walletList = [];
          hideLoader();
        }
      } else {
        hideLoader();
        // todo: need to show message on null response
      }
    } catch (e) {
      hideLoader();
      debugPrint(' Error ==========> ${e.toString()}');
    }
  }

  void walletwithdeawalticket(BuildContext context, String type, String subject, String description, String amount ,) async {
    Dio dio = Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String Token = (prefs.getString('token')).toString();

    final Map<String, String> headers = {
       //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMTE3YzJkNmMzZWUyZDc3ODRhNmNlNGUzMzZiMjVlMThhYWNiMjA2YTg5NTliMGY5N2IyMjc3MTgyMmIxMjUwNTIwOTVmNzkyZTAwNGJmNWQiLCJpYXQiOjE2OTI0NDExNzMuMzE2MjI1LCJuYmYiOjE2OTI0NDExNzMuMzE2MjI5LCJleHAiOjE3MjQwNjM1NzMuMzA5NjgzLCJzdWIiOiIxMyIsInNjb3BlcyI6W119.fh5V4jXJmoZ9CLrmYMnXZzv4BA1H_5Ay_pv_DIiKL5B8UzR8lwZQbc09ytwOPGBPtBQuzeA1nBHVQmbSaGh183VqzsLgPG_obR17rL5LchFC6znS6UZkpqZmsbop4NEpP4OUDLWhh4Za8rmvdroaQeETIvMhXfUMSXF0hshOuokv7TfXWEF6dxih8bTR8fQj9axdV0gXGwdBCXUuXEJEofI_Pk5k-vHSX1sXclH7lCf3jYt-G5fZKs61IZMscK5JX8Eh_HZPv874PYXoMqNafIhzhiFqg8L4dOUWzat7c284BUCTsTwIDwXQTTECvsAjAGpLbQFzK77DCTHf5LqXyQnK81ucHNAQXRMZKR1yzaJLNmXW6ubSbqUwiOcXznZSx5IC38Ho_1jLvIu5RkhtIQY1PosV6TURTT_LgDMKrPnnbWYi8aE4uRz_qy11yhs3HrvN-k74KiVa22PRZ97Txa8p-XiHthEHxxomkTsb_ej77nWx68XJVkYaVROIO53OvxdJq3B-XwMyLna5NhS373Qx3zyqkOQzE1pEzecqTHvMlCkbzmfoVJh3na_Spnf8WVV87VzBu6R-Y_z3mCmHYETWaWzAfREdHD5TVoo1PhNPzL6i9qdPwJ04xpG6WD1gfu0aIoAkJJz1_LW91KlEB5-ANZkMmHX8eWUoc8pzjMI', // Your JWT token
       'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };

    var queryParams = {
      "type": type,
      "subject": subject,
      'description': description,
      'wallet_amount': amount,
    };

    var url = 'https://ishopper.sa/api/v1/customer/support-ticket/create';
    print("URL: $url");
    print("headers Data: $headers");
    print("query Parameters: $queryParams");

    // try {
    //   var response = await dio.get(url, queryParameters: queryParams, options: Options(headers: headers));
    //   final responseData = response.data;
    //   print('responseData ================> $responseData');
    //
    //   Navigator.of(context).pop();
    //   if (responseData['status'] == 200) {
    //     Navigator.of(context).pop();
    //   } else {
    //     print('Error: ${responseData["message"]}');
    //     var messages = responseData["message"];
    //
    //     if (messages.toString().contains("not a wallet amount")) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text("Invalid wallet amount. Please check the amount."),
    //         ),
    //       );
    //     }
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }

    try {
      var response = await dio.get(url, queryParameters: queryParams, options: Options(headers: headers));
      final responseData = response.data;
      print('responseData ================> $responseData');

      Navigator.of(context).pop();
      if (responseData['status'] == 200) {
        Navigator.of(context).pop();
      } else {
        print('Error: ${responseData["message"]}');
        var messages = responseData["message"];
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
