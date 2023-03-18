import 'dart:async';
import 'package:get/get_utils/get_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';

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
        printInfo(info: "SupabaseDatabaseService GetProfile: $data");
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

  Future<List<StoreModel>> getPopularBrands() async {
    final data = await _database
        .from(DatabaseContants.storesTable)
        .select()
        .eq('is_active', true)
        .eq('is_popular', true)
        .order('created_at', ascending: false)
        .limit(10);
    printInfo(info: "SupabaseDatabaseService GetPopularBrands: $data");
    if (data != null) {
      printInfo(info: "SupabaseDatabaseService GetPopularBrands: $data");
      return data.map((e) => StoreModel.fromMap(e)).toList().cast<StoreModel>();
    } else {
      return [];
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final data = await _database
        .from(DatabaseContants.productsTable)
        .select()
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(10);
    if (data != null) {
      printInfo(info: "SupabaseDatabaseService GetPopularBrands: $data");
      return data
          .map((e) => ProductModel.fromMap(e))
          .toList()
          .cast<ProductModel>();
    } else {
      return [];
    }
  }
}
