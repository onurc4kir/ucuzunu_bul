class StoreModel {
  StoreModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.desc,
    required this.adress,
    required this.createdAt,
    required this.isHaveBranch,
    required this.isActive,
    required this.isPopular,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String desc;
  final bool isHaveBranch;
  final bool isActive;
  final bool isPopular;
  final String adress;
  final DateTime createdAt;

  factory StoreModel.fromMap(Map<String, dynamic> json) => StoreModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        desc: json["desc"],
        adress: json["adress"],
        isHaveBranch: json["is_have_branch"],
        isActive: json["is_active"],
        isPopular: json["is_popular"],
        createdAt: DateTime.tryParse(json["created_at"]) ?? DateTime.now(),
      );
}
