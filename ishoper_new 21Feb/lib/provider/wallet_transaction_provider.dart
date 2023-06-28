import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/transaction_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/wallet_transaction_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';

class WalletTransactionProvider extends ChangeNotifier {

  static const String TAG = "WalletTransactionProvider";

  final WalletTransactionRepo transactionRepo;
  bool _isLoading = false;
  bool _firstLoading = false;
  bool _isConvert = false;
  double amount = 0;

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
    Dio dio = Dio();
    try {
      var response = await dio.get('http://ishopper.sa/api/v1/wallet?customer_id=$customerId');
      final responseData = json.decode(response.toString());
      debugPrint("$TAG responseData =========> $responseData");
      if(responseData != null){
        if(responseData["totalBalance"] != null) {
          amount = double.parse(responseData["totalBalance"].toString());
        } else {
          amount = 0;
        }
        if(responseData["CustomerWalletHistory"] != null) {
          walletList.clear();
          walletList = responseData["CustomerWalletHistory"];
        } else {
          walletList = [];
        }
      } else {
        // todo: need to show message on null response
      }
    } catch (e) {
      debugPrint(' Error ==========> ${e.toString()}');
    }
  }
}
