import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/review_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_details_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailsProvider extends ChangeNotifier {
  static const String TAG = "ProductDetailsProvider";
  final TextEditingController bidController = TextEditingController();

  final ProductDetailsRepo productDetailsRepo;

  ProductDetailsProvider({@required this.productDetailsRepo});

  List<ReviewModel> _reviewList;
  int _imageSliderIndex;
  bool _wish = false;
  int _quantity = 0;
  int _variantIndex;
  List<int> _variationIndex;
  int _rating = 0;
  bool _isLoading = false;
  int _orderCount;
  int _wishCount;
  String _sharableLink;
  String _errorText;
  bool _hasConnection = true;
  var auctionData;
  var isActivedata;

  var countBids;
  var starprice;

  var bidesData;
  DateTime currentTime = DateTime.now();
  DateTime upComingIn;
  DateTime diff;
  DateTime endIn;
  DateTime startDate;
  DateTime endDate;
  var startTime;
  var endTime;

  // Countdown Values

  int days;
  int hours;
  int minutes;
  int seconds;

  int days1;
  int hours1;
  int minutes1;
  int seconds1;

  DateTime Now;

  // var differentEndIn1;
  // var differentEndIn2;
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

  List<ReviewModel> get reviewList => _reviewList;

  int get imageSliderIndex => _imageSliderIndex;

  bool get isWished => _wish;

  int get quantity => _quantity;

  int get variantIndex => _variantIndex;

  List<int> get variationIndex => _variationIndex;

  int get rating => _rating;

  bool get isLoading => _isLoading;

  int get orderCount => _orderCount;

  int get wishCount => _wishCount;

  String get sharableLink => _sharableLink;

  String get errorText => _errorText;

  bool get hasConnection => _hasConnection;

  Future<void> initProduct(Product product, BuildContext context) async {
    _hasConnection = true;
    _variantIndex = 0;
    ApiResponse reviewResponse = await productDetailsRepo.getReviews(product.id.toString());
    if (reviewResponse.response != null && reviewResponse.response.statusCode == 200) {
      Provider.of<BannerProvider>(context, listen: false).getProductDetails(context, product.slug.toString());
      _reviewList = [];
      reviewResponse.response.data.forEach((reviewModel) => _reviewList.add(ReviewModel.fromJson(reviewModel)));
      _imageSliderIndex = 0;
      _quantity = 1;
    } else {
      ApiChecker.checkApi(context, reviewResponse);
      if (reviewResponse.error.toString() == 'Connection to API server failed due to internet connection') {
        _hasConnection = false;
      }
    }
    notifyListeners();
  }

  void initData(Product product) {
    _variantIndex = 0;
    _quantity = 1;
    _variationIndex = [];
    product.choiceOptions.forEach((element) => _variationIndex.add(0));
  }

  void removePrevReview() {
    _reviewList = null;
    _sharableLink = null;
  }

  void getCount(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsRepo.getCount(productID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderCount = apiResponse.response.data['order_count'];
      _wishCount = apiResponse.response.data['wishlist_count'];
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void getSharableLink(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsRepo.getSharableLink(productID);

    print("productDetailsRepo.getSharableLink=>${apiResponse}");

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _sharableLink = apiResponse.response.data;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void setErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }

  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  void changeWish() {
    _wish = !_wish;
    notifyListeners();
  }

  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  void setCartVariantIndex(int index) {
    _variantIndex = index;
    _quantity = 1;
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    _quantity = 1;
    notifyListeners();
  }

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(ReviewBody reviewBody, List<File> files, String token) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await productDetailsRepo.submitReview(reviewBody, files, token);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _rating = 0;
      responseModel = ResponseModel('Review submitted successfully', true);
      _errorText = null;
      notifyListeners();
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  auctionDetails(BuildContext context, productId) async {
    showLoader();
    Dio dio = Dio();
    try {
      var response = await dio.get('${AppConstants.BASE_URL}${AppConstants.GET_AUCTION}$productId');
      final responseData = json.decode(response.toString());
      print("$TAG Response  auctionDetails =======> $response");

      if (responseData['status'] == 200 || responseData['status'] == 201) {
        hideLoader();

        if (responseData['status'] == 201) {
          isActivedata = responseData['is_active'];

          print('$TAG auctionData1 =========>201  $isActivedata');
          hideLoader();
        } else {
          auctionData = responseData['data'];
          isActivedata = auctionData['is_active'];
          print('$TAG auctionData1 =========>200  $isActivedata');
          hideLoader();
        }

        var isActive = auctionData['is_active'];
        starprice = auctionData['start_price'];

        print('$TAG auctionData1 =========>  $isActive');
        print('$TAG auctionData.... =========>  $isActive');

        startDate = DateTime.parse(auctionData['from_date'].toString());
        endDate = DateTime.parse(auctionData['to_date'].toString());

        startTime = DateFormat("hh:mm").parse(auctionData['from_time']);
        endTime = DateFormat("hh:mm").parse(auctionData['to_time']);
        upComingIn = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
        endIn = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);

        debugPrint("$TAG Duration ===========> \nupComingIn:$upComingIn\nendIn:$endIn");
      } else {
        debugPrint('$TAG Error =========>  ${responseData["message"]}');
        var messages = responseData["message"];
        hideLoader();
      }
    } catch (e) {
      debugPrint('$TAG Error ==========> ${e.toString()}');
      hideLoader();
    }
  }

  bidSubmit(BuildContext context, model, int productId, var customerId, var bid, String bidAmount) async {
    showLoader();
    Dio dio = Dio();
    try {
      var response = await dio.get("${AppConstants.BASE_URL}${AppConstants.SUBMIT_BID}?product_id=$productId&customer_id=$customerId&bid_amount=${bidAmount}");
      final responseData = json.decode(response.toString());
      print("$TAG responseData ==========> $responseData");
      if (responseData['status'] == 200) {
        if (bid['latest_bid'] == bid['reserve_price']) {
          Fluttertoast.showToast(msg: 'Bid is completed');
          hideLoader();
        } else {
          var message = responseData["message"].toString();

          Fluttertoast.showToast(msg: message.toString());
          hideLoader();
        }
      } else {
        var message = responseData["message"].toString();
        debugPrint('$TAG Error ==========> $message');
        Fluttertoast.showToast(msg: message.toString());
        hideLoader();
      }
    } catch (e) {
      debugPrint('$TAG Error ========>  ${e.toString()}');
      hideLoader();
    }
  }
}
