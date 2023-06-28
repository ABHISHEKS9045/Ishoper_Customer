import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import '../../utill/app_constants.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';

// class CustomerProductRepo {
//   final DioClient dioClient;

//   CustomerProductRepo(this.dioClient);

//   Future<ApiResponse> getChatList() async {
//     try {
//       final response = await dioClient.get(
//           "https://mactosys.com/iShoper/api/v1/get-order-list/customproduct");
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//     }
//   }
// }

class CustomerProductRepo {
  final DioClient dioClient;
  CustomerProductRepo({@required this.dioClient});

  Future<ApiResponse> getTransactionList() async {
    try {
      final Response response = await dioClient.get(
          "https://mactosys.com/iShoper/api/v1/get-order-list/customproduct");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
