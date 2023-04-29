class BranchModel {
  BranchModel({
    required this.id,
    this.name,
    this.adress,
    this.imageUrl,
    this.storeId,
    this.createdAt,
  });

  final String id;
  final String? name;
  final String? adress;
  final String? imageUrl;
  final String? storeId;
  final String? createdAt;

  factory BranchModel.fromMap(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        name: json["name"],
        adress: json["adress"],
        imageUrl: json["image_url"],
        storeId: json["storeId"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "adress": adress,
        "image_url": imageUrl,
        "storeId": storeId,
        "created_at": createdAt,
      };
}
