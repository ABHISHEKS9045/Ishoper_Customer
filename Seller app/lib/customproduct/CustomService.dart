import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

import 'CustomProductModel.dart';
import 'ProductDetailModel.dart';

class CustomService {
  static Future<CustomProductModel> customProduct(String token) async {
    final response = await http.get(
      Uri.parse("http://ishopper.sa/api/v1/sellerlist"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );

    print("custom Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CustomProductModel customProductModel = CustomProductModel.fromJson(data);
      return customProductModel;
    } else {
      throw Exception('Failed to product.');
    }
  }

  static Future<ProductDetailModel> customProductDetail(
      String token, String productId) async {
    final response = await http.get(
      Uri.parse("http://ishopper.sa/iShoper/api/v1/view_custom/" + productId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );

    print("Product detail response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ProductDetailModel productDetailModel = ProductDetailModel.fromJson(data);
      return productDetailModel;
    } else {
      throw Exception('Failed to product.');
    }
  }

  static Future<List<OfferProductModel>> searchOfferProduct(String token,String searchKey) async {
    final response = await http.post(
      Uri.parse("http://ishopper.sa/api/v1/searchbyseller"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
      body: jsonEncode({'name':searchKey})
    );

    print("custom Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<OfferProductModel> list = [];

      for(int i=0;i<data['products'].length;i++){
        OfferProductModel model = OfferProductModel.fromJson(data['products'][i]);
        list.add(model);
      }
      // data['products'].foreach((jsonData){
      //   OfferProductModel model = OfferProductModel.fromJson(jsonData);
      //   list.add(model);
      // });

      return list;
    } else {
      throw Exception('Failed to product.');
    }
  }

  static Future<bool> updateOfferProduct(String token,String customProductId,String offer,String name,String des,String sellerProductId) async {
    final response = await http.post(
        Uri.parse("http://ishopper.sa/api/v1/update/custom_product/"+customProductId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token
        },
        body: jsonEncode({'id':customProductId,'offers':offer,'name':name,'description':des,'seller_offer_id': sellerProductId})
    );

    print("custom Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if(data['status'])
        return true;
      else
        return false;


      // data['products'].foreach((jsonData){
      //   OfferProductModel model = OfferProductModel.fromJson(jsonData);
      //   list.add(model);
      // });

    } else {
      throw Exception('Failed to product.');
    }
  }

  static Future<bool> removeCustomProduct(String token,String id) async {
    final response = await http.post(
        Uri.parse("http://ishopper.sa/api/v1/delete_product/"+id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token
        },
        body: jsonEncode({'id':id})
    );

    print("custom Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if(data['status'])
        return true;
      else
        false;


      // data['products'].foreach((jsonData){
      //   OfferProductModel model = OfferProductModel.fromJson(jsonData);
      //   list.add(model);
      // });

    } else {
      throw Exception('Failed to product.');
    }
  }
}
