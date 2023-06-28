// To parse this JSON data, do
//
//     final viewProductSizeModel = viewProductSizeModelFromJson(jsonString);

import 'dart:convert';

ViewProductSizeModel viewProductSizeModelFromJson(String str) => ViewProductSizeModel.fromJson(json.decode(str));

String viewProductSizeModelToJson(ViewProductSizeModel data) => json.encode(data.toJson());

class ViewProductSizeModel {
  ViewProductSizeModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<Datum> data;

  factory ViewProductSizeModel.fromJson(Map<String, dynamic> json) => ViewProductSizeModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
    this.name,
    this.status,
  });

  int id;
  int categoryId;
  String name;
  int status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    name: json["name"] == null ? null : json["name"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "category_id": categoryId == null ? null : categoryId,
    "name": name == null ? null : name,
    "status": status == null ? null : status,
  };
}
