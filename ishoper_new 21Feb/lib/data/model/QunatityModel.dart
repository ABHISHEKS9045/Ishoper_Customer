// To parse this JSON data, do
//
//     final qunatityModel = qunatityModelFromJson(jsonString);

import 'dart:convert';

QunatityModel qunatityModelFromJson(String str) => QunatityModel.fromJson(json.decode(str));

String qunatityModelToJson(QunatityModel data) => json.encode(data.toJson());

class QunatityModel {
    QunatityModel({
        this.status,
        this.qty,
        this.message,
    });

    bool status;
    String qty;
    String message;

    factory QunatityModel.fromJson(Map<String, dynamic> json) => QunatityModel(
        status: json["status"] == null ? null : json["status"],
        qty: json["qty"] == null ? null : json["qty"],
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "qty": qty == null ? null : qty,
        "message": message == null ? null : message,
    };
}
