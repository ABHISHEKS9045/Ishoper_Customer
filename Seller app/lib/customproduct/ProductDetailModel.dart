// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

import '../data/model/response/chat_model.dart';

ProductDetailModel productDetailModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) =>
    json.encode(data.toJson());

class ProductDetailModel {
  ProductDetailModel({
    this.status,
    this.message,
    this.data,
    this.offer,
    this.reviews,
  });

  int status;
  String message;
  Data data;
  dynamic offer;
  Reviews reviews;
  Customer customer;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        offer: json["offer"],
        reviews:
            json["reviews"] == null ? null : Reviews.fromJson(json["reviews"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "offer": offer,
        "reviews": reviews == null ? null : reviews.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.userId,
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
    this.category,
    this.customerDetails,
    this.reviews,
  });

  int id;
  int userId;
  String categoryId;
  String addedBy;
  String images;
  String description;
  String url;
  dynamic unit;
  int quantity;
  dynamic tax;
  dynamic discount;
  List<String> color;
  String size;
  int brandId;
  int requestStatus;
  int status;
  List<Category> category;
  List<CustomerDetail> customerDetails;
  List<dynamic> reviews;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        images: json["images"] == null ? null : json["images"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        unit: json["unit"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        tax: json["tax"],
        discount: json["discount"],
        color: json["color"] == null
            ? null
            : List<String>.from(json["color"].map((x) => x)),
        size: json["size"] == null ? null : json["size"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        requestStatus:
            json["request_status"] == null ? null : json["request_status"],
        status: json["status"] == null ? null : json["status"],
        category: json["category"] == null
            ? null
            : List<Category>.from(
                json["category"].map((x) => Category.fromJson(x))),
        customerDetails: json["customer_details"] == null
            ? null
            : List<CustomerDetail>.from(json["customer_details"]
                .map((x) => CustomerDetail.fromJson(x))),
        reviews: json["reviews"] == null
            ? null
            : List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "category_id": categoryId == null ? null : categoryId,
        "added_by": addedBy == null ? null : addedBy,
        "images": images == null ? null : images,
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
        "category": category == null
            ? null
            : List<dynamic>.from(category.map((x) => x.toJson())),
        "customer_details": customerDetails == null
            ? null
            : List<dynamic>.from(customerDetails.map((x) => x.toJson())),
        "reviews":
            reviews == null ? null : List<dynamic>.from(reviews.map((x) => x)),
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

class CustomerDetail {
  CustomerDetail({
    this.fullName,
    this.phone,
  });

  String fullName;
  String phone;

  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
        fullName: json["full_name"] == null ? null : json["full_name"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName == null ? null : fullName,
        "phone": phone == null ? null : phone,
      };
}

class Reviews {
  Reviews({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<dynamic> data;
  String firstPageUrl;
  dynamic from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  dynamic to;
  int total;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
        firstPageUrl:
            json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        lastPageUrl:
            json["last_page_url"] == null ? null : json["last_page_url"],
        links: json["links"] == null
            ? null
            : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x)),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from,
        "last_page": lastPage == null ? null : lastPage,
        "last_page_url": lastPageUrl == null ? null : lastPageUrl,
        "links": links == null
            ? null
            : List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total == null ? null : total,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"] == null ? null : json["label"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label == null ? null : label,
        "active": active == null ? null : active,
      };
}
