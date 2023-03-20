import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/models/reward_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class RewardsController extends GetxController {
  late final SupabaseDatabaseService _dbService =
      Get.find<SupabaseDatabaseService>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<RewardModel> items = <RewardModel>[].obs;

  final int limit = 20;

  bool hasMore = true;
  int offset = 0;

  RewardsController() {
    _getItems();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = Get.size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _getItems();
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  Future<void> _getItems() async {
    if (!hasMore) {
      printInfo(info: 'No More Ride');
      return;
    }
    if (isLoading) {
      return;
    }
    _isLoading.value = true;
    final data = await _dbService.getRewardsWithPagination(
      offset: offset,
      limit: limit,
    );

    if (data.length < limit) {
      hasMore = false;
    }
    if (data.isNotEmpty) {
      items.addAll(data);
    }
    offset += 1;
    _isLoading.value = false;
  }
}
