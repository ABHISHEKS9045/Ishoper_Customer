import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/body/MessageBody.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:http/http.dart' as http;
class ChatRepo {
  final DioClient dioClient;
  ChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList() async {
    try {
      final response = await dioClient.get(AppConstants.MESSAGE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> addImage(String imagePath, String type) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPLOAD_PRODUCT_IMAGE_URI}',
    ));
    if(Platform.isAndroid || Platform.isIOS && imagePath != null) {
      File _file = File(imagePath);
      request.files.add(http.MultipartFile('image', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'type': type,
    });
    request.fields.addAll(_fields);
    print('=====> ${request.url.path}\n'+request.fields.toString());
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    print('=====Response body is here==>${res.body}');

    try {
      return ApiResponse.withSuccess(Response(statusCode: response.statusCode, requestOptions: null, statusMessage: response.reasonPhrase, data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addVideo(String imagePath) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPLOAD_PRODUCT_VIDEO_URI}',
    ));
    if(Platform.isAndroid || Platform.isIOS && imagePath != null) {
      File _file = File(imagePath);
      request.files.add(http.MultipartFile('video', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString(AppConstants.TOKEN).toString();
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    // Map<String, String> _fields = Map();
    // _fields.addAll(<String, String>{
    //   'type': type,
    // });
    // request.fields.addAll(_fields);
    print('=====> ${request.url.path}\n'+request.fields.toString());
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    print('=====Response body is here==>${res.body}');

    try {
      return ApiResponse.withSuccess(Response(statusCode: response.statusCode, requestOptions: null, statusMessage: response.reasonPhrase, data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getChatForSeller(userId) async {
    try {
      var params = {
        'user_id' : userId,
      };
      final response = await dioClient.get(AppConstants.MESSAGE_URI_SELLER,queryParameters: params);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendMessage(MessageBody messageBody) async {
    try {
      final response = await dioClient.post(AppConstants.SEND_MESSAGE_URI, data: messageBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendAttachment(MessageBody messageBody,bool isImage) async {
    try {
      Map<String,dynamic> params = messageBody.toJson();
      if(isImage){
        params['images'] = messageBody.message;
        params['message'] = '';
      }else{
        params['message'] = 'Click the link to open video';
        params['videos'] = messageBody.message;
      }


      final response = await dioClient.post(AppConstants.SEND_MESSAGE_URI, data: params);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}