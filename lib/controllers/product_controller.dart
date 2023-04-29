import 'package:get/get.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class ProductController extends GetxController {
  late final _dbService = Get.find<SupabaseDatabaseService>();

  Future<ProductModel?> getProductById(
    String id, {
    bool isBarcode = false,
    bool includePrices = true,
    bool includeBranches = true,
    bool includeStore = true,
  }) async {
    try {
      return await _dbService.getProductById(
        id,
        includePrices: includePrices,
        includeBranches: includeBranches,
        includeStore: includeStore,
      );
    } catch (e) {
      printError(info: "ProductController GetProductById Error: $e");
    }
    return null;
  }

  Future<List<ProductModel>> getProductsWithFilter({
    int offset = 0,
    int limit = 10,
    String? branchId,
    String? storeId,
    bool sortByCreatedDate = true,
    bool? isFeatured,
  }) async {
    try {
      return await _dbService.getProductsWithFilter(
        offset: offset,
        limit: limit,
        branchId: branchId,
        storeId: storeId,
        sortByCreatedDate: sortByCreatedDate,
        isFeatured: isFeatured,
      );
    } catch (e) {
      printError(info: "ProductController GetProductsWithFilter Error: $e");
    }
    return [];
  }
}
