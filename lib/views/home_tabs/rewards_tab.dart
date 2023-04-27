import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/controllers/rewards_controller.dart';
import 'package:ucuzunu_bul/models/reward_model.dart';

class RewardsTab extends GetView<RewardsController> {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      title: "Rewards",
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (!controller.isLoading && controller.items.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 16),
            Text("No rewards added yet"),
          ],
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        itemCount: controller.hasMore
            ? controller.items.length + 1
            : controller.items.length,
        itemBuilder: (context, index) {
          if (controller.hasMore && controller.items.length == index) {
            return const CupertinoActivityIndicator();
          } else {
            final item = controller.items[index];

            return _buildRewardItem(item, context);
          }
        },
      );
    });
  }

  Widget _buildRewardItem(RewardModel item, BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: item.imageUrl!,
            fit: BoxFit.contain,
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 100,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return AlertDialog(
                              title: const Text("Buy Gift Card"),
                              content: const Text(
                                  "Are you sure you want to buy this gift with your points?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      if ((Get.find<AuthController>()
                                                  .user
                                                  ?.point ??
                                              0) <
                                          (item.price)) {
                                        Get.back();
                                        Get.snackbar(
                                          'Error',
                                          'You don\'t have enough points',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }
                                      try {
                                        await controller.buyReward(item.id);
                                        Get.back();
                                        Get.snackbar(
                                          'Success',
                                          'You will get your reward soon, check purchase history',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                        );
                                      } catch (e) {
                                        printError(
                                            info:
                                                "RewardsController BuyReward Error: $e");
                                        Get.snackbar(
                                          'Error',
                                          'Something went wrong, please try again later',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(
                      item.price.toString(),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
