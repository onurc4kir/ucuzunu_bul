import 'dart:io';

import 'package:get/get.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';
import 'package:ucuzunu_bul/models/user_model.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/services/supabase_auth_service.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';
import 'package:ucuzunu_bul/services/supabase_storage_service.dart';

class AuthController extends GetxController {
  late final SupabaseAuthService _authService = Get.find<SupabaseAuthService>();
  late final SupabaseStorageService _storageService =
      Get.find<SupabaseStorageService>();
  late final SupabaseDatabaseService _dbService =
      Get.find<SupabaseDatabaseService>();
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
      print(supaUser?.id);

      if (supaUser != null) {
        _user.value = await _dbService.getProfile(id: supaUser.id);
        return _user.value;
      }
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
      final supaUser = await _authService.signInWithMailAndPassword(
          mail: mail, password: password);

      if (supaUser != null) {
        _user.value = await _dbService.getProfile(id: supaUser.id);
        return _user.value;
      }
    } catch (e) {
      Get.context?.showErrorDialog(message: "$e");
      return null;
    } finally {
      Get.context?.loaderOverlay.hide();
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user.value = null;
    } catch (e) {
      DialogHelper.showErrorDialog(
          context: Get.context!, description: e.toString());
    }
  }

  Future<bool> requestPasswordReset(String mail) async {
    if (mail.isEmpty) {
      return false;
    }

    try {
      Get.context?.loaderOverlay.show();
      await _authService.sendPasswordRenewMail(mail);
      return true;
    } catch (e) {
      Get.context?.showErrorDialog(message: "Error: $e");
      return false;
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<dynamic> registerWithMailAndPassword({
    required String mail,
    required String password,
  }) async {
    try {
      Get.context?.loaderOverlay.show();
      return await _authService.signUpWithMailAndPassword(
          mail: mail, password: password);
    } catch (e) {
      Get.context?.showErrorDialog(message: "Error: $e");
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> updateProfile() async {
    try {
      Get.context?.loaderOverlay.show();
      await _dbService.updateProfile(_user.value!);
    } catch (e) {
      Get.context?.showErrorDialog(message: "Error: $e");
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> updateProfileImage(File file) async {
    try {
      Get.context?.loaderOverlay.show();
      final url = await _storageService.uploadPublicProfilesFile(
        filePath: file.path,
        urlPath: _user.value!.id,
      );
      _user.value!.imageUrl = url;
      await _dbService.updateProfile(_user.value!);
    } catch (e) {
      Get.context?.showErrorDialog(message: "Error: $e");
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }
}
