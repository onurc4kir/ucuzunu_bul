import 'package:get/get.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';
import 'package:ucuzunu_bul/models/price_model.dart';
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
        isBarcode: isBarcode,
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

  Future<List<PriceModel>> getPricesAddedByUser(String id) async {
    try {
      return await _dbService.getPricesAddedByUser(id);
    } catch (e) {
      DialogHelper.showErrorDialog(
        context: Get.context!,
        title: "Hata",
        description: "Fiyatlar getirilirken bir hata oluştu.",
      );
      printError(info: "ProductController GetPricesAddedByUser Error: $e");
    }
    return [];
  }
}
