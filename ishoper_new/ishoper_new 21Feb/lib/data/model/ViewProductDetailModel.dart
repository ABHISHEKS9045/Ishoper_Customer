// To parse this JSON data, do
//
//     final viewProductDetailModel = viewProductDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';

ViewProductDetailModel viewProductDetailModelFromJson(String str) =>
    ViewProductDetailModel.fromJson(json.decode(str));

String viewProductDetailModelToJson(ViewProductDetailModel data) =>
    json.encode(data.toJson());

class ViewProductDetailModel {
  ViewProductDetailModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<Datum> data;

  factory ViewProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ViewProductDetailModel(
        // status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.commonDetails,
    this.offers,
  });

  CommonDetails commonDetails;
  List<Offer> offers;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        commonDetails: json["common_details"] == null
            ? null
            : CommonDetails.fromJson(json["common_details"]),
        offers: json["offers"] == null
            ? null
            : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "common_details": commonDetails == null ? null : commonDetails.toJson(),
        "offers": offers == null
            ? null
            : List<dynamic>.from(offers.map((x) => x.toJson())),
      };
}

class CommonDetails {
  CommonDetails({
    this.id,
    this.categoryId,
    this.name,
    this.addedBy,
    this.images,
    this.description,
    this.url,
    this.unit,
    this.quantity,
    this.tax,
    this.discount,
    this.color,
    this.size,
    this.brandId,
    this.requestStatus,
    this.status,
    this.availableOffers,
    this.category,
  });

  int id;
  String categoryId;
  String name;
  String addedBy;
  List<String> images;
  String description;
  String url;
  dynamic unit;
  int quantity;
  dynamic tax;
  dynamic discount;
  List<Color> color;
  String size;
  int brandId;
  int requestStatus;
  int status;
  int availableOffers;
  List<Category> category;

  factory CommonDetails.fromJson(Map<String, dynamic> json) => CommonDetails(
        id: json["id"] == null ? null : json["id"],
        // categoryId: json["category_id"] == null ? null : json["category_id"][0]['id'],
        name: json["name"] == null ? null : json["name"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        unit: json["unit"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        tax: json["tax"],
        discount: json["discount"],
        color: json["color"] == null
            ? null
            : List<Color>.from(json["color"].map((x) => Color.fromJson(x))),
        size: json["size"] == null ? null : json["size"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        requestStatus:
            json["request_status"] == null ? null : json["request_status"],
        status: json["status"] == null ? null : json["status"],
        availableOffers:
            json["available_offers"] == null ? null : json["available_offers"],
        category: json["category"] == null
            ? null
            : List<Category>.from(
                json["category"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category_id": categoryId == null ? null : categoryId,
        "name": name == null ? null : name,
        "added_by": addedBy == null ? null : addedBy,
        "images": images == null ? null : images,
        "description": description == null ? null : description,
        "url": url == null ? null : url,
        "unit": unit,
        "quantity": quantity == null ? null : quantity,
        "tax": tax,
        "discount": discount,
        "color": color == null
            ? null
            : List<dynamic>.from(color.map((x) => x.toJson())),
        "size": size == null ? null : size,
        "brand_id": brandId == null ? null : brandId,
        "request_status": requestStatus == null ? null : requestStatus,
        "status": status == null ? null : status,
        "available_offers": availableOffers == null ? null : availableOffers,
        "category": category == null
            ? null
            : List<dynamic>.from(category.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.name,
    this.slug,
    this.translations,
  });

  String name;
  String slug;
  List<dynamic> translations;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        translations: json["translations"] == null
            ? null
            : List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "translations": translations == null
            ? null
            : List<dynamic>.from(translations.map((x) => x)),
      };
}

class Color {
  Color({
    this.name,
    this.code,
  });

  String name;
  String code;

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "code": code == null ? null : code,
      };
}

class Offer {
  Offer({
    this.sellers,
    this.offers,
    this.id,
    this.product,
  });

  List<Seller> sellers;
  String offers;
  int id;
  List<Product> product;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        sellers: json["sellers"] == null
            ? null
            : List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),

        offers: json["offers"] == null ? null : json["offers"],
        id: json["id"] == null ? null : json["id"],
        product: json['offer_id'] == null ? null : List<Product>.from(json["offer_id"].map((x) => Product.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
        "sellers": sellers == null
            ? null
            : List<dynamic>.from(sellers.map((x) => x.toJson())),
        "offers": offers == null ? null : offers,
        "id": id == null ? null : id,
      };
}

class Seller {
  Seller({
    this.fullName,
    this.phone,
    this.email,
    this.image,
    this.id
  });

  String fullName;
  String phone;
  String email;
  String image;
  String id;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        fullName: json["full_name"] == null ? null : json["full_name"],
        id: json["seller_id"] == null ? null : json["seller_id"].toString(),
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName == null ? null : fullName,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "image": image == null ? null : image,
      };
}
