import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/explore_container.dart';
import 'package:ucuzunu_bul/controllers/home_explore_controller.dart';
import 'package:ucuzunu_bul/models/store_model.dart';

class HomeTab extends GetView<HomeExploreController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      title: "Home",
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExploreListContainer(
              title: "Popular Brands",
              isShowAllTapButton: false,
              child: SizedBox(
                height: 130,
                child: _buildPopularStores(),
              ),
            ),
            ExploreListContainer(
              title: "Featured Products",
              isShowAllTapButton: false,
              child: _buildFeaturedProducts(),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<StoreModel>> _buildPopularStores() {
    return FutureBuilder(
      future: controller.getPopularBrands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonListTile();
        }
        if (snapshot.data?.isEmpty ?? true) {
          return const Text("Can not find a store");
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final store = snapshot.data![index];

            return ExploreContainerListItem(
              onTap: () {
                Get.toNamed("/store-detail/${store.id}");
              },
              width: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (store.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: store.imageUrl!,
                      fit: BoxFit.contain,
                    ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(120, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        store.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturedProducts() {
    return FutureBuilder(
      future: controller.getFeaturedProducts(),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return SkeletonListTile();
        }

        if (s.data?.isEmpty ?? true) {
          return const Text("Can not find a product");
        }
        return Column(
          children: s.data?.map((e) {
                return ListTile(
                  onTap: () {
                    Get.toNamed("/product-detail/${e.id}");
                  },
                  leading: CachedNetworkImage(
                    imageUrl: e.imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                  title: Text(e.name),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        e.minPriceText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList() ??
              [],
        );
      },
    );
  }
}
