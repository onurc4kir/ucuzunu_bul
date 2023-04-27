class StoreModel {
  StoreModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.desc,
    this.address,
    this.createdAt,
    this.isHaveBranch,
    this.isActive,
    this.isPopular,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final String? desc;
  final bool? isHaveBranch;
  final bool? isActive;
  final bool? isPopular;
  final String? address;
  final DateTime? createdAt;

  factory StoreModel.fromMap(Map<String, dynamic> json) => StoreModel(
        id: json["id"] ?? "no id",
        name: json["name"] ?? "No Name",
        imageUrl: json["image_url"],
        desc: json["desc"],
        address: json["address"],
        isHaveBranch: json["is_have_branch"],
        isActive: json["is_active"],
        isPopular: json["is_popular"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      );
}
