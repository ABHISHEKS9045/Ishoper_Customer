// To parse this JSON data, do
//
//     final addCartProductModel = addCartProductModelFromJson(jsonString);

import 'dart:convert';

AddCartProductModel addCartProductModelFromJson(String str) =>
    AddCartProductModel.fromJson(json.decode(str));

String addCartProductModelToJson(AddCartProductModel data) =>
    json.encode(data.toJson());

class AddCartProductModel {
  AddCartProductModel({
    this.status,
    this.customId,
    this.message,
  });

  bool status;
  int customId;
  String message;

  factory AddCartProductModel.fromJson(Map<String, dynamic> json) =>
      AddCartProductModel(
        status: json["status"] == null ? null : json["status"],
        customId: json["custom_id"] == null ? null : json["custom_id"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "custom_id": customId == null ? null : customId,
        "message": message == null ? null : message,
      };
}
