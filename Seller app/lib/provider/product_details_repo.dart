import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/datasource/remote/dio/dio_client.dart';
import '../data/datasource/remote/exception/api_error_handler.dart';
import '../data/model/response/base/api_response.dart';
import '../utill/app_constants.dart';

class ProductDetailsRepo {
  final DioClient dioClient;
  ProductDetailsRepo({@required this.dioClient});

  Future<ApiResponse> getProduct(String productID, String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.PRODUCT_DETAILS_URI+productID, options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getReviews(String productID) async {
    try {
      final response = await dioClient.get(AppConstants.PRODUCT_REVIEW_URI+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      // return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCount(String productID) async {
    try {
      final response = await dioClient.get(AppConstants.COUNTER_URI+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSharableLink(String productID) async {
    try {
      final response = await dioClient.get(AppConstants.SOCIAL_LINK_URI+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}