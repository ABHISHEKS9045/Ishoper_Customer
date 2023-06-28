import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/MessageBody.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/data/repository/chat_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';

import '../data/model/response/base/error_response.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});
  List<MessageModel> _chatList;
  List<Customer> _customerList;
  List<List<MessageModel>> _customersMessages;
  bool _isSendButtonActive = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MessageModel> get chatList => _chatList;
  List<Customer> get customerList => _customerList;
  bool get isSendButtonActive => _isSendButtonActive;
  List<List<MessageModel>> get customersMessages => _customersMessages;

  void setCustomerMessage(List<MessageModel> value) {
    _customersMessages[1].addAll(value);
  }

  Future<void> initCustomerInfo(BuildContext context) async {
    _customerList = null;
    notifyListeners();
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _customerList = [];
      apiResponse.response.data
          .forEach((chat) => _customerList.add(Customer.fromJson(chat)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> loadChatForSeller(userId) async {
    _customerList = null;
    notifyListeners();
    ApiResponse apiResponse = await chatRepo.getChatForSeller(userId);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _chatList = [];
      apiResponse.response.data
          .forEach((chat) => _chatList.add(MessageModel.fromJson(chat)));
    }
    notifyListeners();
  }
  Future addProductImage(String pickedLogo,String type, Function callback,BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await chatRepo.addImage( pickedLogo , type);
    if(response.response != null && response.response.statusCode == 200) {
      _isLoading = false;

      Map map = jsonDecode(response.response.data);
      String name = map["image_name"];
      String type = map["type"];
      callback(true, name, type,context);
      notifyListeners();
    }else {
      _isLoading = false;
      String errorMessage;
      if (response.error is String) {
        print(response.error.toString());
        errorMessage = response.error.toString();
      } else {
        ErrorResponse errorResponse = response.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '',context);
      _isLoading = false;
      notifyListeners();
    }


  }

  Future addProductVideo(String pickedLogo, Function callback,BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await chatRepo.addVideo( pickedLogo);
    if(response.response != null && response.response.statusCode == 200) {
      _isLoading = false;

      Map map = jsonDecode(response.response.data);
      String name = map["video"];
      String type = 'video';
      callback(true, name, type,context);
      notifyListeners();
    }else {
      _isLoading = false;
      String errorMessage;
      if (response.error is String) {
        print(response.error.toString());
        errorMessage = response.error.toString();
      } else {
        ErrorResponse errorResponse = response.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '',context);
      _isLoading = false;
      notifyListeners();
    }


  }

  Future<void> initChatList(BuildContext context) async {
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _chatList = [];
      _customerList = [];
      _customersMessages = [];
      List<int> _customerIdList = [];
      List<dynamic> _data = apiResponse.response.data.reversed.toList();
      _data.forEach((chat) {
        MessageModel _message = MessageModel.fromJson(chat);
        _chatList.add(_message);
        if (_message.customer != null) {
          if (!_customerIdList.contains(_message.customer.id)) {
            _customerList.add(_message.customer);
            _customerIdList.add(_message.customer.id);
            _customersMessages.add([]);
          }
          _customersMessages[_customerIdList.indexOf(_message.customer.id)]
              .add(_message);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void sendMessage(
      MessageBody messageBody, int customerIndex, BuildContext context) async {
    ApiResponse apiResponse = await chatRepo.sendMessage(messageBody);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _chatList.add(MessageModel(
        sellerId: int.parse(messageBody.userId),
        message: messageBody.message,
        sentByCustomer: 0,
        sentBySeller: 1,
        createdAt: DateConverter.localDateToIsoString(DateTime.now()),
      ));
      _customersMessages[customerIndex].add(MessageModel(
        sellerId: int.parse(messageBody.userId),
        message: messageBody.message,
        sentByCustomer: 0,
        sentBySeller: 1,
        createdAt: DateConverter.localDateToIsoString(DateTime.now()),
      ));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
  }

  void sendAttachment(
      MessageBody messageBody,bool isImage, int customerIndex, BuildContext context) async {
    ApiResponse apiResponse = await chatRepo.sendAttachment(messageBody,isImage);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      MessageModel model = MessageModel(
        sellerId: int.parse(messageBody.userId),
        message: isImage ?  '' : 'Click the link to open video',
        sentByCustomer: 0,
        sentBySeller: 1,
        createdAt: DateConverter.localDateToIsoString(DateTime.now()),
      );
      if(isImage)
        model.image = messageBody.message;
      else
        model.video = messageBody.message;

      _chatList.add(model);
      _customersMessages[customerIndex].add(model);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
  }


  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }
}
