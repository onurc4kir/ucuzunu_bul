import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/search_controller.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late final SearchController controller = Get.find<SearchController>();
  Timer? _timer;
  String? previousKeyword;
  void searchWithThrottle(String keyword, {int? throttleTime}) {
    _timer?.cancel();
    if (keyword != previousKeyword) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 550), (timer) {
        controller.searchText = keyword;
        _timer?.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      title: "Search",
      body: Column(
        children: [
          CustomInputArea(
            inputFieldPadding: EdgeInsets.zero,
            textField: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: controller.searchText,
                      decoration: const InputDecoration(
                        hintText: "Search by product name or barcode",
                      ),
                      onChanged: (search) {
                        searchWithThrottle(search);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await FlutterBarcodeScanner.scanBarcode(
                          '#ff6666',
                          'Cancel',
                          true,
                          ScanMode.BARCODE,
                        ).then((value) {
                          if (value.isNotEmpty) {
                            Get.find<SearchController>().searchText = value;
                          }
                        });
                      } catch (e) {
                        printError(info: e.toString());
                      }
                    },
                    icon: const Icon(Icons.barcode_reader),
                  ),
                ],
              ),
            ),
          ),
          _buildSearchResult(),
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    return Expanded(child: Obx(
      () {
        if (controller.searchText.isEmpty) {
          return _buildOldSearches();
        }

        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.searchText.isNotEmpty && controller.products.isEmpty) {
          return Center(
            child: SelectableText(
                "No product found with this: ${controller.searchText}"),
          );
        }
        return GridView.builder(
          itemCount: controller.products.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (c, i) {
            final item = controller.products[i];
            return Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.imageUrl,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(240, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 8,
                        right: 8,
                        bottom: 4,
                      ),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    ));
  }

  Widget _buildOldSearches() {
    return const Center(
      child: SizedBox(),
    );
  }
}
