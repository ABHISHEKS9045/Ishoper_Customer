// To parse this JSON data, do
//
//     final customProductModel = customProductModelFromJson(jsonString);

import 'dart:convert';

import '../data/model/response/chat_model.dart';

CustomProductModel customProductModelFromJson(String str) =>
    CustomProductModel.fromJson(json.decode(str));

String customProductModelToJson(CustomProductModel data) =>
    json.encode(data.toJson());

class CustomProductModel {
  CustomProductModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<Datum> data;

  factory CustomProductModel.fromJson(Map<String, dynamic> json) =>
      CustomProductModel(
        status: json["status"] == null ? null : json["status"],
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
class OfferProductModel{
  String name;
  String price;
  String imgURL;
  String id;

  OfferProductModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['purchase_price'].toString();
    id = json["id"].toString();
    imgURL = json['images'][0];
  }
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
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
    this.user,
    this.categoryName,
    this.name,
    this.material,
    this.customer
  });

  int id;
  String name;
  String categoryId;
  String categoryName;
  String addedBy;
  dynamic images;
  String description;
  String url;
  dynamic unit;
  int quantity;
  dynamic tax;
  dynamic discount;
  List<String> color;
  String size;
  String material;
  int brandId;
  int requestStatus;
  int status;
  int availableOffers;
  User user;
  Customer customer;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? "[No Name]" : json["name"],
        // categoryId: json["category_id"] == null ? null : int.parse(jsonDecode(json["category_id"])[0]['id'].toString()),
        categoryId: json["category_id"] == null ? null : json["category_id"][0]['name'],
        addedBy: json["added_by"] == null ? null : json["added_by"],
      material: json["material"] == null ? null : json["material"],
        images: json["images"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        unit: json["unit"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        tax: json["tax"],
        discount: json["discount"],
        color: (json["color"] == null && json["color"].length==0)
            ? null
            : List<String>.from(json["color"].map((name) => name['name'])),
        size: json["size"] == null ? null : json["size"],
        categoryName: json["category_id"] == null ? null : json["category_id"].length>0 ? json["category_id"][0]["name"] : "",
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        requestStatus:
            json["request_status"] == null ? null : json["request_status"],
        status: json["status"] == null ? null : json["status"],
        availableOffers:
            json["available_offers"] == null ? null : json["available_offers"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    customer : Customer.fromJson(json['user'])
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category_id": categoryId == null ? null : categoryId,
        "added_by": addedBy == null ? null : addedBy,
        "images": images,
        "description": description == null ? null : description,
        "url": url == null ? null : url,
        "unit": unit,
        "quantity": quantity == null ? null : quantity,
        "tax": tax,
        "discount": discount,
        "color": color == null ? null : List<dynamic>.from(color.map((x) => x)),
        "size": size == null ? null : size,
        "brand_id": brandId == null ? null : brandId,
        "request_status": requestStatus == null ? null : requestStatus,
        "status": status == null ? null : status,
        "available_offers": availableOffers == null ? null : availableOffers,
        "user": user == null ? null : user.toJson(),
      };
}

class User {
  User({
    this.id,
    this.name,
    this.fName,
    this.lName,
    this.phone,
    this.image,
    this.email,
    this.emailVerifiedAt,
    this.streetAddress,
    this.country,
    this.city,
    this.zip,
    this.houseNo,
    this.apartmentNo,
    this.isActive,
    this.paymentCardLastFour,
    this.paymentCardBrand,
    this.paymentCardFawryToken,
    this.loginMedium,
    this.socialId,
    this.isPhoneVerified,
    this.isEmailVerified,
  });

  int id;
  dynamic name;
  String fName;
  String lName;
  String phone;
  String image;
  String email;
  dynamic emailVerifiedAt;
  dynamic streetAddress;
  dynamic country;
  dynamic city;
  dynamic zip;
  dynamic houseNo;
  dynamic apartmentNo;
  int isActive;
  dynamic paymentCardLastFour;
  dynamic paymentCardBrand;
  dynamic paymentCardFawryToken;
  dynamic loginMedium;
  dynamic socialId;
  int isPhoneVerified;
  int isEmailVerified;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
        fName: json["f_name"] == null ? null : json["f_name"],
        lName: json["l_name"] == null ? null : json["l_name"],
        phone: json["phone"] == null ? null : json["phone"],
        image: json["image"] == null ? null : json["image"],
        email: json["email"] == null ? null : json["email"],
        emailVerifiedAt: json["email_verified_at"],
        streetAddress: json["street_address"],
        country: json["country"],
        city: json["city"],
        zip: json["zip"],
        houseNo: json["house_no"],
        apartmentNo: json["apartment_no"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        paymentCardLastFour: json["payment_card_last_four"],
        paymentCardBrand: json["payment_card_brand"],
        paymentCardFawryToken: json["payment_card_fawry_token"],
        loginMedium: json["login_medium"],
        socialId: json["social_id"],
        isPhoneVerified: json["is_phone_verified"] == null
            ? null
            : json["is_phone_verified"],
        isEmailVerified: json["is_email_verified"] == null
            ? null
            : json["is_email_verified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name,
        "f_name": fName == null ? null : fName,
        "l_name": lName == null ? null : lName,
        "phone": phone == null ? null : phone,
        "image": image == null ? null : image,
        "email": email == null ? null : email,
        "email_verified_at": emailVerifiedAt,
        "street_address": streetAddress,
        "country": country,
        "city": city,
        "zip": zip,
        "house_no": houseNo,
        "apartment_no": apartmentNo,
        "is_active": isActive == null ? null : isActive,
        "payment_card_last_four": paymentCardLastFour,
        "payment_card_brand": paymentCardBrand,
        "payment_card_fawry_token": paymentCardFawryToken,
        "login_medium": loginMedium,
        "social_id": socialId,
        "is_phone_verified": isPhoneVerified == null ? null : isPhoneVerified,
        "is_email_verified": isEmailVerified == null ? null : isEmailVerified,
      };
}
