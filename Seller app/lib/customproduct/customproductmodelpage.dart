import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repository/customer_product_repo.dart';
import '../utill/app_constants.dart';

class CustomProductlistModel extends ChangeNotifier {
  CustomerProductRepo customerRepo;

  bool _loading = false;
  bool get loading => _loading;

  List _customerproductList = [];
  List get customerproductList => _customerproductList;

  toggle() {
    _loading = !_loading;
    notifyListeners();
  }

  String token;
  customproductlist() async {
    _customerproductList = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString(AppConstants.TOKEN);
    print(token);

    Dio dio = Dio();
    var response = await dio.get(
      "http://ishopper.sa/api/v1/get-order-list/customproduct",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    print(" mahima ${response.data}");
    final responseData = jsonDecode(response.toString());
    print("customproductlist responseData  $responseData");
  }
}
