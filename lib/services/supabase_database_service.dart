import 'dart:async';
import 'package:get/get_utils/get_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/models/reward_model.dart';
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
    if (data != null) {
      return data.map((e) => StoreModel.fromMap(e)).toList().cast<StoreModel>();
    } else {
      return [];
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final data = await _database
        .from(DatabaseContants.productsTable)
        .select("""*,prices(
        id,
        price,
        store_id,
        branch_id
        )""")
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(10);
    if (data != null) {
      return data
          .map((e) => ProductModel.fromMap(e))
          .toList()
          .cast<ProductModel>();
    } else {
      return [];
    }
  }

  Future<List<ProductModel>> searchProductByNameOrBarcode(
      String searchText) async {
    final data = await _database
        .from(DatabaseContants.productsTable)
        .select()
        .or("name.ilike.%$searchText%,barcode.ilike.%$searchText%)")
        .limit(30);

    if (data != null) {
      return data
          .map((e) => ProductModel.fromMap(e))
          .toList()
          .cast<ProductModel>();
    } else {
      return [];
    }
  }

  Future<List<RewardModel>> getRewardsWithPagination(
      {required int offset, required int limit}) async {
    final start = offset * limit;
    final data = await _database
        .from(DatabaseContants.rewardsTable)
        .select()
        .range(start, start + limit)
        .order("created_at");
    if (data != null) {
      return data
          .map((e) => RewardModel.fromMap(e))
          .toList()
          .cast<RewardModel>();
    } else {
      return [];
    }
  }

  Future<ProductModel> getProductById(
    String id, {
    bool includePrices = false,
    bool includeBranches = false,
    bool includeStore = false,
  }) async {
    const branchQuery = """branches(
        id,
        name,
        latitude,
        longitude
        )""";
    const storeQuery = """stores(
        id,
        name
        )""";
    final priceQuery = """prices(
        id,
        price
        ${includeBranches ? ',$branchQuery' : ''}
        ${includeStore ? ',$storeQuery' : ''}
        )""";

    final data = await _database.from(DatabaseContants.productsTable).select("""
          *
          ${includePrices ? ',$priceQuery' : ''}
          """).eq('id', id).single();
    print(data);
    return ProductModel.fromMap(data);
  }

  Future<ProductModel> getProductByBarcode(id) async {
    return await _database
        .from(DatabaseContants.productsTable)
        .select()
        .eq('barcode', id)
        .single()
        .then((value) => ProductModel.fromMap(value));
  }
}
