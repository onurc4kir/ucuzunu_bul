class BranchModel {
  BranchModel({
    required this.id,
    this.name,
    this.adress,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.storeId,
    this.createdAt,
  });

  final String id;
  final String? name;
  final String? adress;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? storeId;
  final String? createdAt;

  factory BranchModel.fromMap(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        name: json["name"],
        adress: json["adress"],
        latitude: json["latitude"] != null ? json["latitude"] + .0 : null,
        longitude: json["longitude"] != null ? json["longitude"] + .0 : null,
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
