import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/controllers/product_controller.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';

class UserPriceHistory extends StatelessWidget {
  static const String route = "/user-price-history";
  const UserPriceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Price History",
      body: FutureBuilder(
        future: Get.find<ProductController>()
            .getPricesAddedByUser(Get.find<AuthController>().user!.id),
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (s.data?.isEmpty ?? true) {
            return const Center(
              child: Text("You have not added any price yet"),
            );
          }

          return ListView.builder(
            itemCount: s.data!.length,
            itemBuilder: (c, i) {
              final priceModel = s.data![i];

              return ListTile(
                onTap: () {},
                title: Text(priceModel.product?.name ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      priceModel.createdAt?.formattedDateForUIWithTime ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      priceModel.priceText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
