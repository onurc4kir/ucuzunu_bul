class BranchModel {
  BranchModel({
    required this.id,
    required this.name,
    required this.adress,
    required this.imageUrl,
    required this.storeId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String adress;
  final String imageUrl;
  final String storeId;
  final String createdAt;

  factory BranchModel.fromMap(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        name: json["name"],
        adress: json["adress"],
        imageUrl: json["image_url"],
        storeId: json["storeId"],
        createdAt: json["createdAt"],
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
