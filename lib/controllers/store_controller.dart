import 'package:get/get.dart';
import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class StoreController extends GetxController {
  late final _dbService = Get.find<SupabaseDatabaseService>();

  Future<StoreModel?> getStoreById(String id) async {
    return await _dbService.getStoreById(id);
  }

  Future<List<BranchModel>> getBranchesWithFilter({
    int offset = 0,
    int limit = 5,
    String? storeId,
    bool sortByCreatedDate = true,
  }) async {
    return await _dbService.getBranchesWithFilter(
      offset: offset,
      limit: limit,
      storeId: storeId,
      sortByCreatedDate: sortByCreatedDate,
    );
  }
}
