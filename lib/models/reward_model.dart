class RewardModel {
  RewardModel({
    required this.id,
    required this.name,
    required this.price,
    this.desc,
    this.imageUrl,
    this.isActive,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? desc;
  final String? imageUrl;
  final int price;
  final bool? isActive;
  final String? createdAt;

  factory RewardModel.fromMap(Map<String, dynamic> json) => RewardModel(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        imageUrl: json["image_url"],
        price: json["price"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "desc": desc,
        "image_url": imageUrl,
        "price": price,
        "is_active": isActive,
        "created_at": createdAt,
      };
}
