import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/controllers/geolocator_controller.dart';
import 'package:ucuzunu_bul/controllers/product_controller.dart';
import 'package:ucuzunu_bul/models/branch_model.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/views/support_page.dart';

import '../components/custom_input_area.dart';
import '../controllers/store_controller.dart';

class AddPricePage extends StatefulWidget {
  final String productId;
  final bool isBarcode;
  const AddPricePage({
    super.key,
    required this.productId,
    this.isBarcode = true,
  });

  @override
  State<AddPricePage> createState() => _AddPricePageState();
}

class _AddPricePageState extends State<AddPricePage> {
  ProductModel? product;
  List<BranchModel> branches = [];
  String? error;
  bool isLoading = true;

  String? branchId;
  double? price;
  bool get isButtonEnabled => branchId != null && price != null;

  @override
  void initState() {
    _fetchProductDetails();
    super.initState();
  }

  _fetchProductDetails() async {
    try {
      isLoading = true;
      product = await Get.find<ProductController>().getProductById(
        widget.productId,
        isBarcode: widget.isBarcode,
        includeStore: false,
        includeBranches: true,
      );
      branches = await  Get.find<StoreController>().getBranchesWithFilter(
        limit: 5,
        geohash: Get.find<GeolocatorController>().getGeoHash()?.substring(0, 6),
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Add Price",
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: CustomShapedButton(
          onPressed: () async {
            if (isButtonEnabled) {
              try {
                await Get.find<StoreController>()
                    .addPrice(
                      productId: widget.productId,
                      branchId: branchId!,
                      price: price!,
                      storeId:
                          branches.firstWhere((e) => e.id == branchId).storeId,
                    )
                    .then((value) => {
                          Get.back(),
                          context.showSuccessSnackBar(
                            message:
                                "Price Added Successfully, We will check it.",
                          )
                        });
              } catch (e) {
                context.showErrorDialog(message: "Error Adding Price: $e");
                return;
              }
            }
          },
          enabled: isButtonEnabled,
          text: "Add Price",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildAddPriceBody(),
    );
  }

  Widget _buildAddPriceBody() {
    if (isLoading) {
      return SkeletonParagraph();
    }
    if (error != null) {
      return Center(
        child: Text(error!),
      );
    }

    if (product == null) {
      return const Center(
        child: Text("Product Not Found"),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              product!.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product!.name),
            subtitle: Text(product!.desc),
            trailing: Column(
              children: [
                Text(product!.minPriceText),
                Text(product!
                        .minPriceModel?.createdAt?.formattedDateForUIWithTime ??
                    ""),
              ],
            ),
          ),
          CustomInputArea(
            textField: TextFormField(
              onChanged: (value) => setState(() {
                price = double.tryParse(value);
              }),
              onSaved: (newValue) {
                price = double.tryParse(newValue!);
              },
              decoration: const InputDecoration(
                labelText: "Price",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9]*(?:\.[0-9]*)?$')),
              ],
            ),
          ),
          CustomInputArea(
              suffixWidgets: [
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Didn't Find Branch?",
                      content: Column(
                        children: [
                          const Text(
                            "If you didn't find branch, you can let us know",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              Get.toNamed(SupportPage.route);
                            },
                            child: const Text("Support Page"),
                          )
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.question_mark,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                )
              ],
              labelString: "Select Branch",
              textField: DropdownButtonFormField(
                icon: const SizedBox(),
                decoration: const InputDecoration(
                  labelText: "Select Branch",
                ),
                items: branches
                    .map((e) => DropdownMenuItem(
                        value: e.id, child: Text(e.name ?? "No Name")))
                    .toList(),
                onChanged: (s) {
                  setState(() {
                    branchId = s;
                  });
                },
              ))
        ],
      ),
    );
  }
}
