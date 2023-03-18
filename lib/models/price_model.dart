class PriceModel {
  PriceModel({
    required this.id,
    required this.price,
    required this.productId,
    required this.storeId,
    required this.branchId,
    required this.createdAt,
  });

  final String id;
  final double price;
  final String productId;
  final String storeId;
  final String branchId;
  final String createdAt;

  factory PriceModel.fromMap(Map<String, dynamic> json) => PriceModel(
        id: json["id"],
        price: json["price"],
        productId: json["product_id"],
        storeId: json["store_id"],
        branchId: json["branch_id"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "price": price,
        "product_id": productId,
        "store_id": storeId,
        "branch_id": branchId,
        "created_at": createdAt,
      };
}
