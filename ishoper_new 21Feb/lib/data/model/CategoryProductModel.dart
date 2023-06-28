// To parse this JSON data, do
//
//     final categoryProductModel = categoryProductModelFromJson(jsonString);

import 'dart:convert';

CategoryProductModel categoryProductModelFromJson(String str) => CategoryProductModel.fromJson(json.decode(str));

String categoryProductModelToJson(CategoryProductModel data) => json.encode(data.toJson());

class CategoryProductModel {
    CategoryProductModel({
        this.status,
        this.message,
        this.data,
    });

    int status;
    String message;
    List<Datum> data;

    factory CategoryProductModel.fromJson(Map<String, dynamic> json) => CategoryProductModel(
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
        this.name,
        this.slug,
        this.icon,
        this.parentId,
        this.position,
        this.homeStatus,
        this.priority,
        this.translations,
    });

    int id;
    String name;
    String slug;
    String icon;
    int parentId;
    int position;
    int homeStatus;
    int priority;
    List<dynamic> translations;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        icon: json["icon"] == null ? null : json["icon"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        position: json["position"] == null ? null : json["position"],
        homeStatus: json["home_status"] == null ? null : json["home_status"],
        priority: json["priority"] == null ? null : json["priority"],
        translations: json["translations"] == null ? null : List<dynamic>.from(json["translations"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "icon": icon == null ? null : icon,
        "parent_id": parentId == null ? null : parentId,
        "position": position == null ? null : position,
        "home_status": homeStatus == null ? null : homeStatus,
        "priority": priority == null ? null : priority,
        "translations": translations == null ? null : List<dynamic>.from(translations.map((x) => x)),
    };
}
