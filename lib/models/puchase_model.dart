class PurchaseModel {
  final String id;
  final String? rewardId;
  final String? userId;
  final String? code;
  final bool? status;
  final DateTime? createdAt;

  PurchaseModel({
    required this.id,
    this.rewardId,
    this.userId,
    this.code,
    this.status,
    this.createdAt,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> json) => PurchaseModel(
        id: json["id"],
        rewardId: json["rewardId"],
        userId: json["userId"],
        code: json["code"],
        status: json["status"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "rewardId": rewardId,
        "userId": userId,
        "code": code,
        "status": status,
        "created_at": createdAt,
      };
  
}