import 'package:get/get.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
