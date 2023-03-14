import 'package:get/get.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';
import 'package:ucuzunu_bul/models/user_model.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/services/supabase_auth_service.dart';

class AuthController extends GetxController {
  late final SupabaseAuthService _authService = Get.find<SupabaseAuthService>();
  final Rx<User?> _user = Rx(null);
  User? get user => _user.value;

  bool get isLoggedIn => _user.value != null ? true : false;
  AuthController() {
    currentUser();
  }
  Future<User?> currentUser() async {
    try {
      Get.context?.loaderOverlay.show();
      final supaUser = _authService.currentUser();
    } catch (e) {
      Get.context?.loaderOverlay.hide();

      return null;
    } finally {
      Get.context?.loaderOverlay.hide();
    }
    return null;
  }

  Future<User?> login(String mail, String password) async {
    try {
      Get.context?.loaderOverlay.show();

      return null;
    } catch (e) {
      Get.context?.showErrorDialog(message: "$e");
      return null;
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> logout() async {
    try {
      _user.value = null;

      //await Get.deleteAll();
    } catch (e) {
      DialogHelper.showErrorDialog(
          context: Get.context!, description: e.toString());
    }
  }

  Future<bool> requestPasswordReset(String username) async {
    if (username.isEmpty) {
      return false;
    }
    try {
      Get.context?.loaderOverlay.show();
      return false;
    } catch (e) {
      Get.context?.showErrorDialog(message: "Error: $e");
      return false;
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }
}
