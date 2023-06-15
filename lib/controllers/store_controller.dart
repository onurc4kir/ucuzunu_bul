import 'package:get/get.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class StoreController extends GetxController {
  late final _dbService = Get.find<SupabaseDatabaseService>();
  late final _authController = Get.find<AuthController>();

  Future<StoreModel?> getStoreById(String id) async {
    return await _dbService.getStoreById(id);
  }

  Future<List<BranchModel>> getBranchesWithFilter(
      {int offset = 0,
      int limit = 5,
      String? storeId,
      bool sortByCreatedDate = true,
      String? geohash}) async {
    printInfo(info: "StoreController getBranchesWithFilter: $geohash");
    return await _dbService.getBranchesWithFilter(
        offset: offset,
        limit: limit,
        storeId: storeId,
        sortByCreatedDate: sortByCreatedDate,
        geohash: geohash);
  }

  Future<void> addPrice(
      {required String productId,
      required String branchId,
      required double price,
      String? storeId}) async {
    await _dbService.addPrice(
      productId: productId,
      branchId: branchId,
      price: price,
      userId: _authController.user!.id,
      storeId: storeId,
    );
  }
}
