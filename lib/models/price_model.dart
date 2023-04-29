import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';

class PriceModel {
  PriceModel({
    required this.id,
    required this.price,
    this.productId,
    this.storeId,
    this.branchId,
    this.branch,
    this.store,
    this.createdAt,
  });

  final String id;
  final double price;
  final String? productId;
  final String? storeId;
  final String? branchId;
  final DateTime? createdAt;
  final BranchModel? branch;
  final StoreModel? store;

  factory PriceModel.fromMap(Map<String, dynamic> json) => PriceModel(
        id: json["id"],
        price: json["price"] + .0,
        productId: json["product_id"],
        storeId: json["store_id"],
        branchId: json["branch_id"],
        store:
            json['stores'] != null ? StoreModel.fromMap(json['stores']) : null,
        branch: json['branches'] != null
            ? BranchModel.fromMap(json['branches'])
            : null,
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      );

  Map<String, dynamic> toMap() => {
        "price": price,
        "product_id": productId,
        "store_id": storeId,
        "branch_id": branchId,
      };
  String get priceText => "${price.toStringAsFixed(2)} ₺";
}
