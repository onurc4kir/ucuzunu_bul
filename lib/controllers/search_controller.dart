import 'package:get/get.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class SearchController extends GetxController {
  final SupabaseDatabaseService _databaseService =
      Get.find<SupabaseDatabaseService>();
  final RxList<ProductModel> _products = RxList<ProductModel>([]);
  List<ProductModel> get products => _products;

  final RxString _searchText = ''.obs;
  String get searchText => _searchText.value;

  set searchText(String value) {
    _searchText.value = value;
    _searchProducts(value);
  }

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  _searchProducts(String searchText, {bool updateTextField = false}) async {
    try {
      if (updateTextField) {
        _searchText.value = searchText;
      }
      _isLoading.value = true;
      final data =
          await _databaseService.searchProductByNameOrBarcode(searchText);
      _products.value = data;
    } catch (e) {
      Get.context?.showErrorSnackBar(message: e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
