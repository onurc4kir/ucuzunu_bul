import 'package:ucuzunu_bul/models/reward_model.dart';

class PurchaseModel {
  final String id;
  final String? rewardId;
  final String? userId;
  final String? code;
  final bool? status;
  final DateTime? createdAt;
  final RewardModel? reward;

  PurchaseModel({
    required this.id,
    this.rewardId,
    this.userId,
    this.code,
    this.status,
    this.createdAt,
    this.reward,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> json) => PurchaseModel(
        id: json["id"],
        rewardId: json["rewardId"],
        userId: json["userId"],
        code: json["code"],
        status: json["status"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        reward: json['rewards'] != null
            ? RewardModel.fromMap(json['rewards'])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "rewardId": rewardId,
        "userId": userId,
      };
}
