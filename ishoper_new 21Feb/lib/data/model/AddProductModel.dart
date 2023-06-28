// To parse this JSON data, do
//
//     final addProductModel = addProductModelFromJson(jsonString);

import 'dart:convert';

AddProductModel addProductModelFromJson(String str) => AddProductModel.fromJson(json.decode(str));

String addProductModelToJson(AddProductModel data) => json.encode(data.toJson());

class AddProductModel {
    AddProductModel({
        this.status,
        this.error,
        this.message,
        this.response,
    });

    int status;
    String error;
    String message;
    Response response;

    factory AddProductModel.fromJson(Map<String, dynamic> json) => AddProductModel(
        status: json["status"] == null ? null : json["status"],
        error: json["error"] == null ? null : json["error"],
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "error": error == null ? null : error,
        "message": message == null ? null : message,
        "response": response == null ? null : response.toJson(),
    };
}

class Response {
    Response({
        this.color,
        this.addedBy,
        this.url,
        this.name,
        this.categoryId,
        this.size,
        this.quantity,
        this.description,
        this.images,
        this.id,
    });

    String color;
    String addedBy;
    Url url;
    String name;
    String categoryId;
    String size;
    String quantity;
    String description;
    String images;
    int id;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        color: json["color"] == null ? null : json["color"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        url: json["url"] == null ? null : Url.fromJson(json["url"]),
        name: json["name"] == null ? null : json["name"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        size: json["size"] == null ? null : json["size"].toString(),
        quantity: json["quantity"] == null ? null : json["quantity"],
        description: json["description"] == null ? null : json["description"],
        images: json["images"] == null ? null : json["images"],
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "color": color == null ? null : color,
        "added_by": addedBy == null ? null : addedBy,
        "url": url == null ? null : url.toJson(),
        "name": name == null ? null : name,
        "category_id": categoryId == null ? null : categoryId,
        "size": size == null ? null : size,
        "quantity": quantity == null ? null : quantity,
        "description": description == null ? null : description,
        "images": images == null ? null : images,
        "id": id == null ? null : id,
    };
}

class Url {
    Url();

    factory Url.fromJson(Map<String, dynamic> json) => Url(
    );

    Map<String, dynamic> toJson() => {
    };
}
