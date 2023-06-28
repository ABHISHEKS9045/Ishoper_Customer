import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_sixvalley_ecommerce/data/model/CommonModel.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/QunatityModel.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/SellerCartModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import '../data/model/AddCardModel.dart';
import '../data/model/AddProductModel.dart';
import '../data/model/CategoryProductModel.dart';
import '../data/model/ColorProductModel.dart';
import '../data/model/ViewProductDetailModel.dart';
import '../data/model/ViewProductModel.dart';

import '../data/model/ViewProductSizeModel.dart';
import '../data/model/getSizeAndMatrial.dart';

class ServiceProduct {
  static Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static String BaseUrl = "http://ishopper.sa/api/v1/customer/";
  static String BaseUrlCart = "http://ishopper.sa/api/v1/cart/";
  static String customerstoreApi = BaseUrl + "customerstore";
  static String colorApi = BaseUrl + "color";
  static String categoryApi = BaseUrl + "category";
  static String subCategoryApi = BaseUrl + "sub_category_list";
  static String viewProductApi = BaseUrl + "custom_product/list";
  static String viewProductDetailApi = BaseUrl + "offer_product/list/";
  static String unit_listApi = BaseUrl + "unit_list/";
  static String addToCardApi = BaseUrlCart + "add/custom";
  static String ViewCartApi = BaseUrlCart + "customlist";
  static String deleteCartApi = BaseUrlCart + "remove/custom";
  static String updateQuantity = BaseUrlCart + "update/custom";
  static String sizeApi = 'http://ishopper.sa/api/v1/getSizeAndMaterials?category_id=';

  static Future<AddProductModel> uploadFileAddProduct(
      String description,
      String color,
      int quantity,
      String category_id,
      String subCatId,
      List<XFile> images,
      XFile videoUrl,
      String token,
      String size,
      String name,

      ) async {
    var request = http.MultipartRequest("POST", Uri.parse(customerstoreApi));
    // add text fields
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    };
    request.fields['description'] = description;
    request.fields['color[]'] = color;
    request.fields['quantity'] = quantity.toString();
    request.fields['category_id'] = category_id;
    request.fields['size'] = size;
    request.fields['name'] = name;
    request.fields['sub_category_id'] = subCatId;

    request.headers.addAll(headers);

    print("add product request" + request.fields.toString());
    print("image suucess 1 >>>" + images.toString());
    print("image suucess video >>>" + videoUrl.toString());

    for(var i = 0; i< images.length; i++){
      var pic = await http.MultipartFile(
          'images[]',File(images[i].path).readAsBytes().asStream(), File(images[i].path).lengthSync(),
          filename: images[i].path.split("/").last);

      var pic1 = await http.MultipartFile(
          'url',File(images[i].path).readAsBytes().asStream(), File(images[i].path).lengthSync(),
          filename: images[i].path.split("/").last);
      request.files.add(pic);
      request.files.add(pic1);
    //
    //
    }

    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("add_product_response" + responseString.toString());
    var data = jsonDecode(responseString);
    AddProductModel addProductModel = AddProductModel.fromJson(data);
    return addProductModel;
  }

  Future<ColorProductModel> colorProduct(String token) async {
    final response = await http.get(
      Uri.parse(colorApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("color Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ColorProductModel colorProductModel = ColorProductModel.fromJson(data);
      return colorProductModel;
    } else {
      throw Exception('Failed to color product.');
    }
  }

  Future<CategoryProductModel> categoryProduct(String token) async {
    final response = await http.get(
      Uri.parse(categoryApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );

    print("category Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CategoryProductModel categoryProductModel =
          CategoryProductModel.fromJson(data);
      return categoryProductModel;
    } else {
      throw Exception('Failed to category product.');
    }
  }

  Future<CategoryProductModel> subCategoryProduct(String token,subCat) async {
    final response = await http.get(
      Uri.parse(subCategoryApi+'/$subCat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );

    print("category Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      CategoryProductModel categoryProductModel =
      CategoryProductModel.fromJson(data);
      return categoryProductModel;
    } else {
      throw Exception('Failed to category product.');
    }
  }

  Future<ViewProductModel> viewProduct(String token) async {
    final response = await http.get(
      Uri.parse(viewProductApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token,
      },
    );
    print("token bearer    " + token);

    print("view Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ViewProductModel viewProductModel = ViewProductModel.fromJson(data);
      return viewProductModel;
    } else {
      throw Exception('Failed to product.');
    }
  }

  Future<bool> deleteProduct(String token,String id) async {
    final response = await http.post(
      Uri.parse('https://mactosys.com/iShoper/api/v1/delete_product/'+id),
      headers: <String, String>{
        "Authorization": "Bearer " + token,
      },
      body: {"id":id}
    );
    print("token bearer    " + token);

    // print("view Product response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if(data['status'])
        return true;
      else
        return false;
    } else {
      throw Exception('Failed to product.');
    }
  }

  Future<ViewProductDetailModel> viewProductDetail(
      String token, String productId) async {
    final response = await http.get(
      Uri.parse(viewProductDetailApi + productId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );
    print(viewProductDetailApi + productId);

    print("view Product detail response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ViewProductDetailModel viewProductDetailModel =
          ViewProductDetailModel.fromJson(data);
      return viewProductDetailModel;
    } else {
      throw Exception('Failed to product.');
    }
  }

  Future<ViewProductSizeModel> viewProductSize(
      String token, String categoryId) async {
    final response = await http.get(
      Uri.parse('$sizeApi$categoryId'),
      // Uri.parse(unit_listApi + categoryId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );
    print('$sizeApi$categoryId');
    // print(unit_listApi + categoryId);

    print("view Product size response>>>" + response.body);




    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(">>>>>>data$data ");
      ViewProductSizeModel viewProductSizeModel =
          ViewProductSizeModel.fromJson(data);
      return viewProductSizeModel;
    } else {
      throw Exception('Failed to product.');
    }
  }

  Future<GetSizeAndMaterialModel> getSizeAndMaterialModel(
      String token, String categoryId) async {
    final response = await http.get(
      Uri.parse('$sizeApi$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
    );
    print('$sizeApi$categoryId');

    print("view Product size response>>>" + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      GetSizeAndMaterialModel getSizeAndMaterialModel =
      GetSizeAndMaterialModel.fromJson(data);
      return getSizeAndMaterialModel;
    } else {
      throw Exception('Failed to product.');
    }
  }


  static Future<AddCartProductModel> addToCard(String token, String id) async {
    final params = {"id": id, "quantity": "1"};
    print('add cart params' + params.toString());

    http.Response responce = await http.post(
      Uri.parse(addToCardApi),
      body: params,
      headers: {"Authorization": "Bearer " + token},
    );

    print('add cart response ' + responce.body);

    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body);
      AddCartProductModel user = AddCartProductModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(responce.body.toString());
      AddCartProductModel user = AddCartProductModel.fromJson(data);
      return user;
    }
  }

  static Future<SellerCartModel> viewCard(String token) async {
    http.Response responce = await http.get(
      Uri.parse(ViewCartApi),
      headers: {"Authorization": "Bearer " + token},
    );

    print('view cart response ' + responce.body);

    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body);
      SellerCartModel user = SellerCartModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(responce.body.toString());
      SellerCartModel user = SellerCartModel.fromJson(data);
      return user;
    }
  }

  static Future<CommonModel> deleteCard(String token, var id) async {
    final params = {"id": id};
    print(' cart delete params' + params.toString());
    http.Response responce = await http.post(
      Uri.parse(deleteCartApi),
      body: params,
      headers: {"Authorization": "Bearer " + token},
    );

    print('view cart delete response ' + responce.body);

    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body);
      CommonModel user = CommonModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(responce.body.toString());
      CommonModel user = CommonModel.fromJson(data);
      return user;
    }
  }

  static Future<QunatityModel> updateQuantityCart(
      String token, var id, var quantity) async {
    final params = {"id": id, "quantity": quantity};
    print('quantity params' + params.toString());
    http.Response responce = await http.post(
      Uri.parse(updateQuantity),
      body: params,
      headers: {"Authorization": "Bearer " + token},
    );

    print('quantity response ' + responce.body);

    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body);
      QunatityModel user = QunatityModel.fromJson(data);
      return user;
    } else {
      var data = jsonDecode(responce.body.toString());
      QunatityModel user = QunatityModel.fromJson(data);
      return user;
    }
  }
}
