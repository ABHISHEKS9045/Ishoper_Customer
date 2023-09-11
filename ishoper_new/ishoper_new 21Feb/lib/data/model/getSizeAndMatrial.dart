// To parse this JSON data, do
//
//     final getSizeAndMaterialModel = getSizeAndMaterialModelFromJson(jsonString);

import 'dart:convert';

GetSizeAndMaterialModel getSizeAndMaterialModelFromJson(String str) => GetSizeAndMaterialModel.fromJson(json.decode(str));

String getSizeAndMaterialModelToJson(GetSizeAndMaterialModel data) => json.encode(data.toJson());

class GetSizeAndMaterialModel {
  GetSizeAndMaterialModel({
    this.sizes,
    this.material,
  });

  List<String> sizes;
  List<String> material;

  factory GetSizeAndMaterialModel.fromJson(Map<String, dynamic> json) => GetSizeAndMaterialModel(
    sizes: List<String>.from(json["sizes"].map((x) => x)),
    material: List<String>.from(json["material"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sizes": List<dynamic>.from(sizes.map((x) => x)),
    "material": List<dynamic>.from(material.map((x) => x)),
  };
}
