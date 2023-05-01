import 'dart:async';
import 'package:get/get_utils/get_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';
import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/models/puchase_model.dart';
import 'package:ucuzunu_bul/models/reward_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';
import 'package:ucuzunu_bul/models/support_ticket_model.dart';

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

  Future<List<ProductModel>> getFeaturedProducts({String? geoHash}) async {
    final data = await _database
        .from(DatabaseContants.productsTable)
        .select("""*,prices!inner(
        id,
        price,
        store_id,
        branch_id,
        created_at,
        branches!inner(
        id,
        geohash)
        )""")
        .eq('is_featured', true)
        .like("prices.branches.geohash", geoHash != null ? "$geoHash%" : "%")
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
    bool isBarcode = false,
    bool includePrices = false,
    bool includeBranches = false,
    bool includeStore = false,
    String? geoHash,
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
        price,
        created_at
        ${includeBranches ? ',$branchQuery' : ''}
        ${includeStore ? ',$storeQuery' : ''}
        )""";

    final data = await _database
        .from(DatabaseContants.productsTable)
        .select("""
          *
          ${includePrices ? ',$priceQuery' : ''}
          """)
        .like("prices.branches.geohash", geoHash != null ? "$geoHash%" : "%")
        .eq(isBarcode ? 'barcode' : 'id', id)
        .single();
    return ProductModel.fromMap(data);
  }

  Future<void> buyReward({
    required String userId,
    required String rewardId,
  }) async {
    return await _database.from(DatabaseContants.purchaseTable).insert({
      'user_id': userId,
      'reward_id': rewardId,
    });
  }

  Future<List<PurchaseModel>> getPurchases({required String userId}) async {
    try {
      final data = await _database
          .from(DatabaseContants.purchaseTable)
          .select("*,rewards(id,name,desc,price)")
          .eq('user_id', userId);

      if (data != null) {
        return data
            .map((e) => PurchaseModel.fromMap(e))
            .toList()
            .cast<PurchaseModel>();
      } else {
        return [];
      }
    } catch (e) {
      printError(info: "SupabaseDatabaseService GetPurchases Error: $e");
      rethrow;
    }
  }

  Future<StoreModel?> getStoreById(String id) async {
    final data = await _database
        .from(DatabaseContants.storesTable)
        .select()
        .eq('id', id)
        .single();
    if (data == null) {
      return null;
    }
    return StoreModel.fromMap(data);
  }

  Future<List<ProductModel>> getProductsWithFilter({
    int offset = 0,
    int limit = 10,
    String? branchId,
    String? storeId,
    bool sortByCreatedDate = true,
    bool? isFeatured,
  }) async {
    supa.PostgrestFilterBuilder query =
        _database.from(DatabaseContants.productsTable).select("""
            select distinct on (products) *,
            prices!inner(
            id,
            price,
            store_id,
            created_at,
            branch_id)
            """);

    if (branchId != null) {
      query = query.eq('prices.branch_id', branchId);
    }
    if (storeId != null) {
      query = query.eq('prices.store_id', storeId);
    }
    if (isFeatured != null) {
      query = query.eq('is_featured', isFeatured);
    }

    final data = await query
        .order('created_at', ascending: sortByCreatedDate)
        .limit(limit)
        .range(offset, offset * limit + offset);
    if (data != null) {
      return data
          .map((e) => ProductModel.fromMap(e))
          .toList()
          .cast<ProductModel>();
    } else {
      return [];
    }
  }

  Future<List<BranchModel>> getBranchesWithFilter({
    int offset = 0,
    int limit = 10,
    String? storeId,
    bool sortByCreatedDate = true,
    String? geohash,
  }) async {
    printInfo(info: "geohash: $geohash");
    supa.PostgrestFilterBuilder query =
        _database.from(DatabaseContants.branchesTable).select();

    if (storeId != null) {
      query = query.eq('store_id', storeId);
    }
    if (geohash != null) {
      query = query.like('geohash', "$geohash%");
    }

    final data = await query.order('created_at', ascending: sortByCreatedDate);

    if (data != null) {
      return data
          .map((e) => BranchModel.fromMap(e))
          .toList()
          .cast<BranchModel>();
    } else {
      return [];
    }
  }

  Future<void> addPrice({
    required String productId,
    required String branchId,
    required double price,
    required String userId,
    String? storeId,
  }) async {
    return await _database.from(DatabaseContants.pricesTable).insert({
      'product_id': productId,
      'branch_id': branchId,
      'store_id': storeId,
      'price': price,
      'user_id': userId,
    });
  }

  Future<void> createSupportTicket(SupportTicketModel support) {
    return _database
        .from(DatabaseContants.supportTable)
        .insert(support.toMap());
  }
}
