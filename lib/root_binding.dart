import 'package:get/get.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/services/supabase_auth_service.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';
import 'package:ucuzunu_bul/services/supabase_storage_service.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SupabaseStorageService());
    Get.put(SupabaseDatabaseService());
    Get.put(SupabaseAuthService());
    Get.put(AuthController(), permanent: true);
  }
}
