import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/rewards_controller.dart';
import 'package:ucuzunu_bul/models/puchase_model.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';

class PurchaseHistoryPage extends StatelessWidget {
  static const String route = "/purchase-history";
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Purchase History",
      body: FutureBuilder(
        future: Get.find<RewardsController>().getPurchases(),
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (s.data?.isEmpty ?? true) {
            return const Center(
              child: Text("You have not purchased anything yet"),
            );
          }

          return ListView.builder(
            itemCount: s.data!.length,
            itemBuilder: (c, i) {
              final purchase = s.data![i];

              return ListTile(
                onTap: () {},
                title: Text(purchase.reward?.name ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPurchaseDesc(purchase),
                    const SizedBox(height: 2),
                    Text(
                      purchase.createdAt?.formattedDateForUIWithTime ?? "",
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
                      purchase.reward?.price.toString() ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusIndicator(purchase.status),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(bool? status) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == true
            ? Colors.green
            : status == false
                ? Colors.red
                : Colors.orange,
      ),
    );
  }

  Widget _buildPurchaseDesc(PurchaseModel purchase) {
    String desc = "";
    if (purchase.status == null) {
      desc = "Waiting for approval";
    } else if (purchase.status!) {
      desc = "Your Code: ${purchase.code}";
    } else {
      desc = "Rejected";
    }

    return Text(desc);
  }
}
