import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/product_details_repo.dart';

import '../data/model/response/base/api_response.dart';

import '../data/model/response/product_model.dart';
import '../data/model/response/review_model.dart' as re;
import '../helper/api_checker.dart';
import 'banner_provider.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductDetailsRepo productDetailsRepo;
  ProductDetailsProvider({@required this.productDetailsRepo});

  List<re.ReviewModel> _reviewList;
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




  List auctionProductData = [];
  List<bool> isShowList = [];


  Future<void> getAuctionproduct(productId) async {
    String url = "https://ishopper.sa/api/v1/products/details?id=$productId";

    try {
      var response = await Dio().get(url);
      print("getAuctionproduct $response");

      final responseData = response.data;


        auctionProductData = response.data;
        print("auctionProductDataaa$responseData");
        isShowList =  List.filled(auctionProductData.length,false);
        notifyListeners();


    } catch (e) {
      if (e is DioError) {
        if (e.response?.data['message'] == null) {
          // Handle error
        } else {
          // Handle error
        }
      }

      print('exception>>>>${e.toString()}');
    }
  }


  List<re.ReviewModel> get reviewList => _reviewList;
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
        Provider.of<BannerProvider>(context,listen: false).getProductDetails(context, product.slug.toString());
      _reviewList = [];
      reviewResponse.response.data.forEach((reviewModel) => _reviewList.add(re.ReviewModel.fromJson(reviewModel)));
      _imageSliderIndex = 0;
      _quantity = 1;
    } else {
      ApiChecker.checkApi(context, reviewResponse);
      if(reviewResponse.error.toString() == 'Connection to API server failed due to internet connection') {
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

}
