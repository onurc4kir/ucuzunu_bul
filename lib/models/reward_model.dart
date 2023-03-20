class RewardModel {
  RewardModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.couponCode,
    required this.price,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String desc;
  final String couponCode;
  final int price;
  final bool isActive;
  final String createdAt;

  factory RewardModel.fromMap(Map<String, dynamic> json) => RewardModel(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        couponCode: json["coupon_code"],
        price: json["price"],
        isActive: json["is_active"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "desc": desc,
        "coupon_code": couponCode,
        "price": price,
        "is_active": isActive,
        "created_at": createdAt,
      };
}
