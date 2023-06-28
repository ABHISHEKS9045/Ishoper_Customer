// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
    ErrorModel({
        this.success,
        this.message,
    });

    bool success;
    Message message;

    factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message.toJson(),
    };
}

class Message {
    Message({
        this.images,
    });

    List<String> images;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
    };
}
