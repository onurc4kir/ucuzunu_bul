import 'package:ucuzunu_bul/models/price_model.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.imageUrl,
    required this.barcode,
    required this.createdAt,
    this.prices = const [],
  });

  final String id;
  final String name;
  final String desc;
  final String imageUrl;
  final String barcode;
  final String createdAt;
  final List<PriceModel> prices;

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        imageUrl: json["image_url"],
        barcode: json["barcode"],
        createdAt: json["created_at"],
        prices: json["price"] is List
            ? (json["price"] as List).map((e) => PriceModel.fromMap(e)).toList()
            : [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "desc": desc,
        "image_url": imageUrl,
        "barcode": barcode,
        "created_at": createdAt,
      };

  double get price => prices.isNotEmpty ? prices.first.price : 0.0;

  String get priceText => "${price.toStringAsFixed(2)} ₺";
}
