import 'dart:async';
import 'package:get/get_utils/get_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';

import '../models/user_model.dart';

class SupabaseDatabaseService {
  final _database = supa.Supabase.instance.client;

  Future<User?> getProfile({
    required String id,
  }) async {
    try {
      final data = await _database
          .from(DatabaseContants.profilesTable)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data != null) {
        //printInfo(info: "SupabaseDatabaseService GetProfile: $data");
        return User.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      printError(info: "SupabaseDatabaseService GetProfile Error: $e");
      rethrow;
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      await _database
          .from(DatabaseContants.profilesTable)
          .update(user.toMap())
          .eq('id', user.id);
    } catch (e) {
      printError(info: "SupabaseDatabaseService UpdateProfile Error: $e");
      rethrow;
    }
  }

  Future<void> markProfileCompleted(String id) async {
    try {
      await _database
          .from(DatabaseContants.profilesTable)
          .update({'is_profile_completed': true}).eq('id', id);
    } catch (e) {
      printError(info: "SupabaseDatabaseService UpdateProfile Error: $e");
      rethrow;
    }
  }

  Future<bool?> fillYourProfile({
    required id,
    required String surName,
    required String name,
    required String? countryCode,
  }) async {
    try {
      await _database.from(DatabaseContants.profilesTable).update({
        'full_name': '$name $surName',
        'country_code': countryCode,
        'is_profile_completed': true,
      }).eq('id', id);
      return true;
    } catch (e) {
      printError(info: "SupabaseDatabaseService FillYourProfile Error: $e");
      rethrow;
    }
  }

  Future<void> removeVehicle({
    required String vehicleId,
    required String driverId,
  }) async {
    try {
      await _database
          .from(DatabaseContants.vehiclesTable)
          .delete()
          .eq('id', vehicleId)
          .eq('driver_id', driverId);
    } catch (e) {
      printError(info: "SupabaseDatabaseService RemoveVehicle Error: $e");
      rethrow;
    }
  }

  Future<void> changeDriverOnlineStatus(
      {required bool isOnline, required String id}) async {
    try {
      await _database
          .from(DatabaseContants.profilesTable)
          .update({'is_online': isOnline}).eq(
        'id',
        id,
      );
    } catch (e) {
      printError(
          info: "SupabaseDatabaseService ChangeDriverOnlineStatus Error: $e");
      rethrow;
    }
  }

  Future<void> disableAccount({required String id}) async {
    try {
      await _database
          .from(DatabaseContants.profilesTable)
          .update({'is_active': false}).eq(
        'id',
        id,
      );
    } catch (e) {
      printError(info: "SupabaseDatabaseService DisableAccount Error: $e");
      rethrow;
    }
  }

  // Stream listenUserBalance({required String userId}) {
  //   return _database.from(DatabaseContants.userWalletTable).stream(
  //     primaryKey: ['id'],
  //   ).eq(
  //     "id",
  //     userId,
  //   );
  // }
}
