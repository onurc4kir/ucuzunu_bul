import 'package:get/get.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class ProductController extends GetxController {
  late final _dbService = Get.find<SupabaseDatabaseService>();

  Future<ProductModel?> getProductById(String id) async {
    try {
      return await _dbService.getProductById(
        id,
        includePrices: true,
        includeBranches: true,
        includeStore: true,
      );
    } catch (e) {
      printError(info: "ProductController GetProductById Error: $e");
    }
    return null;
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      return await _dbService.getProductByBarcode(barcode);
    } catch (e) {
      printError(info: "ProductController GetProductByBarcode Error: $e");
    }
    return null;
  }
}
