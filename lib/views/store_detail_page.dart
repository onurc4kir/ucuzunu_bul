import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/product_controller.dart';
import 'package:ucuzunu_bul/controllers/store_controller.dart';
import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/models/store_model.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/views/product_detail_page.dart';

class StoreDetailPage extends StatefulWidget {
  static const route = "/store-detail";
  const StoreDetailPage({super.key});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  StoreModel? store;
  bool isLoading = true;
  String? error;
  final String? storeId = Get.parameters["storeId"];
  @override
  void initState() {
    _fetchStoreDetail();
    super.initState();
  }

  _fetchStoreDetail() async {
    if (storeId == null) {
      error = "Please Provide ProductId";
      isLoading = false;
      setState(() {});
      return;
    }

    try {
      isLoading = true;

      final data = await Get.find<StoreController>().getStoreById(
        storeId!,
      );

      if (data == null) {
        error = "Store Not Found";
      } else {
        store = data;
      }
      return;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title: store?.name, body: _buildStoreDetailBody());
  }

  Widget _buildStoreDetailBody() {
    if (isLoading) {
      return SkeletonParagraph(
        style: const SkeletonParagraphStyle(
            lines: 20,
            spacing: 4,
            lineStyle: SkeletonLineStyle(
              randomLength: true,
            )),
      );
    }

    if (error != null) {
      return Center(
        child: Text(error!),
      );
    }

    if (store == null) {
      return const Center(
        child: Text("Product Not Found"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (store?.imageUrl != null)
            AspectRatio(
              aspectRatio: 2.4,
              child: CachedNetworkImage(
                imageUrl: store!.imageUrl!,
                height: 50,
                width: 50,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            store?.name ?? "no name",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (store?.desc != null)
            Text(
              store!.desc!,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 16),
          _buildLatestProductsSection(),
          const SizedBox(height: 16),
          _buildLatestBranchesSection(),
        ],
      ),
    );
  }

  Widget _buildLatestBranchesSection() {
    if (store == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Latest Branches",
          style: Get.textTheme.titleLarge,
        ),
        const Divider(),
        FutureBuilder(
            future: Get.find<StoreController>()
                .getBranchesWithFilter(storeId: store!.id),
            builder: (c, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return SkeletonParagraph();
              }

              if (s.hasError) {
                return Center(
                  child: Text(s.error.toString()),
                );
              }

              if (s.hasData) {
                final branches = s.data as List<BranchModel>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: branches.length,
                  itemBuilder: (c, i) {
                    final branch = branches[i];
                    return ListTile(
                      title: Text(branch.name ?? "No Name"),
                      subtitle: Text(branch.adress ?? ""),
                    );
                  },
                );
              }

              return const Center(
                child: Text("No Branch Found"),
              );
            }),
      ],
    );
  }

  Widget _buildLatestProductsSection() {
    if (store == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Latest Products",
          style: Get.textTheme.titleLarge,
        ),
        const Divider(),
        FutureBuilder(
            future: Get.find<ProductController>().getProductsWithFilter(
              storeId: store!.id,
              limit: 3,
            ),
            builder: (c, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return SkeletonParagraph();
              }

              if (s.hasError) {
                return Center(
                  child: Text(s.error.toString()),
                );
              }

              if (s.hasData) {
                final products = s.data as List<ProductModel>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (c, i) {
                    final product = products[i];
                    return ListTile(
                      onTap: () {
                        Get.toNamed("${ProductDetailPage.route}/${product.id}");
                      },
                      leading: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        width: 30,
                        height: 30,
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                          product.createdAt?.formattedDateForUIWithTime ?? ""),
                      trailing: Text(product.minPriceText),
                    );
                  },
                );
              }

              return const Center(
                child: Text("No Product Found"),
              );
            }),
      ],
    );
  }
}
