import 'package:get/get.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class HomeExploreController extends GetxController {
  late final _dbService = Get.find<SupabaseDatabaseService>();
  Future<List<StoreModel>> getPopularBrands() async {
    try {
      return await _dbService.getPopularBrands();
    } catch (e) {
      printError(info: "HomeExploreController GetPopularBrands Error: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      return await _dbService.getFeaturedProducts();
    } catch (e) {
      printError(info: "HomeExploreController GetFeaturedProducts Error: $e");
      return [];
    }
  }
}
