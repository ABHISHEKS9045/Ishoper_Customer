// To parse this JSON data, do
//
//     final sellerCartModel = sellerCartModelFromJson(jsonString);

import 'dart:convert';

SellerCartModel sellerCartModelFromJson(String str) => SellerCartModel.fromJson(json.decode(str));

String sellerCartModelToJson(SellerCartModel data) => json.encode(data.toJson());

class SellerCartModel {
    SellerCartModel({
        this.status,
        this.message,
        this.data,
    });

    bool status;
    String message;
    List<Datum> data;

    factory SellerCartModel.fromJson(Map<String, dynamic> json) => SellerCartModel(
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
        this.customerId,
        this.cartGroupId,
        this.productId,
        this.customProductId,
        this.color,
        this.choices,
        this.variations,
        this.variant,
        this.quantity,
        this.price,
        this.tax,
        this.size,
        this.discount,
        this.slug,
        this.name,
        this.images,
        this.thumbnail,
        this.sellerId,
        this.sellerIs,
        this.createdAt,
        this.updatedAt,
        this.shopInfo,
        this.shippingCost,
        this.shippingType,
    });

    int id;
    int customerId;
    String cartGroupId;
    dynamic productId;
    int customProductId;
    String color;
    List<dynamic> choices;
    dynamic variations;
    String variant;
    int quantity;
    int price;
    int tax;
    int size;
    int discount;
    dynamic slug;
    String name;
    String images;
    dynamic thumbnail;
    dynamic sellerId;
    String sellerIs;
    DateTime createdAt;
    DateTime updatedAt;
    String shopInfo;
    dynamic shippingCost;
    dynamic shippingType;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        cartGroupId: json["cart_group_id"] == null ? null : json["cart_group_id"],
        productId: json["product_id"],
        customProductId: json["custom_product_id"] == null ? null : json["custom_product_id"],
        color: json["color"] == null ? null : json["color"],
        choices: json["choices"] == null ? null : List<dynamic>.from(json["choices"].map((x) => x)),
        variations: json["variations"],
        variant: json["variant"] == null ? null : json["variant"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        tax: json["tax"] == null ? null : json["tax"],
        size: json["size"] == null ? null : json["size"],
        discount: json["discount"] == null ? null : json["discount"],
        slug: json["slug"],
        name: json["name"] == null ? null : json["name"],
        images: json["images"] == null ? null : json["images"],
        thumbnail: json["thumbnail"],
        sellerId: json["seller_id"],
        sellerIs: json["seller_is"] == null ? null : json["seller_is"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        shopInfo: json["shop_info"] == null ? null : json["shop_info"],
        shippingCost: json["shipping_cost"],
        shippingType: json["shipping_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "customer_id": customerId == null ? null : customerId,
        "cart_group_id": cartGroupId == null ? null : cartGroupId,
        "product_id": productId,
        "custom_product_id": customProductId == null ? null : customProductId,
        "color": color == null ? null : color,
        "choices": choices == null ? null : List<dynamic>.from(choices.map((x) => x)),
        "variations": variations,
        "variant": variant == null ? null : variant,
        "quantity": quantity == null ? null : quantity,
        "price": price == null ? null : price,
        "tax": tax == null ? null : tax,
        "size": size == null ? null : size,
        "discount": discount == null ? null : discount,
        "slug": slug,
        "name": name == null ? null : name,
        "images": images == null ? null : images,
        "thumbnail": thumbnail,
        "seller_id": sellerId,
        "seller_is": sellerIs == null ? null : sellerIs,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "shop_info": shopInfo == null ? null : shopInfo,
        "shipping_cost": shippingCost,
        "shipping_type": shippingType,
    };
}
