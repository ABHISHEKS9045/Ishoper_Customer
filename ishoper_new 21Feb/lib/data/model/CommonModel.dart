// To parse this JSON data, do
//
//     final commonModel = commonModelFromJson(jsonString);

import 'dart:convert';

CommonModel commonModelFromJson(String str) => CommonModel.fromJson(json.decode(str));

String commonModelToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
    CommonModel({
        this.status,
        this.message,
    });

    bool status;
    String message;

    factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
    };
}
