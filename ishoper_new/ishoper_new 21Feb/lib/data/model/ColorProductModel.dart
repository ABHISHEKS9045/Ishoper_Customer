// To parse this JSON data, do
//
//     final colorProductModel = colorProductModelFromJson(jsonString);

import 'dart:convert';

ColorProductModel colorProductModelFromJson(String str) => ColorProductModel.fromJson(json.decode(str));

String colorProductModelToJson(ColorProductModel data) => json.encode(data.toJson());

class ColorProductModel {
    ColorProductModel({
        this.status,
        this.message,
        this.dataColor,
    });

    int status;
    String message;
    List<DatumColor> dataColor = [];

    factory ColorProductModel.fromJson(Map<String, dynamic> json) => ColorProductModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        dataColor: json["data"] == null ? null : List<DatumColor>.from(json["data"].map((x) => DatumColor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": dataColor == null ? null : List<dynamic>.from(dataColor.map((x) => x.toJson())),
    };
}

class DatumColor {
    DatumColor({
        this.id,
        this.name,
        this.code,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String name;
    String code;
    DateTime createdAt;
    DateTime updatedAt;

    factory DatumColor.fromJson(Map<String, dynamic> json) => DatumColor(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
