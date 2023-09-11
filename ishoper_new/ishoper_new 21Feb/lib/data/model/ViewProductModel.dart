// To parse this JSON data, do
//
//     final viewProductModel = viewProductModelFromJson(jsonString);

import 'dart:convert';

ViewProductModel viewProductModelFromJson(String str) => ViewProductModel.fromJson(json.decode(str));

String viewProductModelToJson(ViewProductModel data) => json.encode(data.toJson());

class ViewProductModel {
    ViewProductModel({
        this.status,
        this.message,
        this.data,
    });

    int status;
    String message;
    List<DatumProduct> data;

    factory ViewProductModel.fromJson(Map<String, dynamic> json) => ViewProductModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<DatumProduct>.from(json["data"].map((x) => DatumProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumProduct {
    DatumProduct({
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
        this.name
    });

    int id;
    String name;
    dynamic categoryId;
    AddedBy addedBy;
    List<String> images;
    String description;
    String url;
    int unit;
    int quantity;
    dynamic tax;
    dynamic discount;
    List<Color> color;
    String size;
    int brandId;
    int requestStatus;
    int status;
    int availableOffers;

    factory DatumProduct.fromJson(Map<String, dynamic> json) => DatumProduct(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? "[No Name]" : json["name"],
        categoryId: json["category_id"],
        addedBy: json["added_by"] == null ? null : addedByValues.map[json["added_by"]],
        images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        unit: json["unit"] == null ? null : json["unit"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        tax: json["tax"],
        discount: json["discount"],
        color: json["color"] == null ? null : List<Color>.from(json["color"].map((x) => Color.fromJson(x))),
        // color: json["color"] == null ? null : [Color(name: "",code: jsonDecode(json["color"][0]))],
        size: json["size"] == null ? null : json["size"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        requestStatus: json["request_status"] == null ? null : json["request_status"],
        status: json["status"] == null ? null : json["status"],
        availableOffers: json["available_offers"] == null ? null : json["available_offers"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category_id": categoryId,
        "added_by": addedBy == null ? null : addedByValues.reverse[addedBy],
        "images": images == null ? null : images,
        "description": description == null ? null : description,
        "url": url == null ? null : url,
        "unit": unit == null ? null : unit,
        "quantity": quantity == null ? null : quantity,
        "tax": tax,
        "discount": discount,
        "color": color == null ? null : List<dynamic>.from(color.map((x) => x.toJson())),
        "size": size == null ? null : size,
        "brand_id": brandId == null ? null : brandId,
        "request_status": requestStatus == null ? null : requestStatus,
        "status": status == null ? null : status,
        "available_offers": availableOffers == null ? null : availableOffers,
    };
}

enum AddedBy { CUSTOMER }

final addedByValues = EnumValues({
    "customer": AddedBy.CUSTOMER
});

class CategoryIdElement {
    CategoryIdElement({
        this.id,
        this.position,
    });

    String id;
    int position;

    factory CategoryIdElement.fromJson(Map<String, dynamic> json) => CategoryIdElement(
        id: json["id"] == null ? null : json["id"],
        position: json["position"] == null ? null : json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "position": position == null ? null : position,
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

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
