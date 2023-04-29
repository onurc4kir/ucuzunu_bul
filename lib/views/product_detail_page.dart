import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:ucuzunu_bul/components/custom_cached_image_container.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/product_controller.dart';
import 'package:ucuzunu_bul/core/theme/colors.style.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/models/product_model.dart';
import 'package:ucuzunu_bul/views/support_page.dart';

class ProductDetailPage extends StatefulWidget {
  static const String route = "/product-detail";
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final String? productId = Get.parameters["productId"];
  ProductModel? product;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    _fetchProductDetail();
    super.initState();
  }

  _fetchProductDetail() async {
    if (productId == null) {
      error = "Please Provide ProductId";
      isLoading = false;
      setState(() {});
      return;
    }

    try {
      isLoading = true;

      final data = await Get.find<ProductController>().getProductById(
        productId!,
      );

      if (data == null) {
        error = "Product Not Found";
      } else {
        product = data;
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
    return CustomScaffold(
      title: "Product Detail",
      trailing: IconButton(
        onPressed: () {
          Get.toNamed(SupportPage.route);
        },
        icon: const Icon(Icons.report_problem),
      ),
      body: _buildProductDetail(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductDetail() {
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

    if (product == null) {
      return const Center(
        child: Text("Product Not Found"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CustomCachedImageContainer(
              imageUri: product?.imageUrl,
              height: 100,
              width: 100,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product?.name ?? "no name",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (product?.desc != null)
            Text(
              product?.desc ?? "no desc",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            "Prices",
            style: Get.textTheme.titleLarge,
          ),
          const Divider(),
          Column(
            children: product?.prices
                    .map(
                      (e) => ListTile(
                        onTap: () {
                          //TODO: OPEN ON THE MAP
                        },
                        title: Text(e.branch?.name ?? "no branch"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.store?.name ?? "no store"),
                            if (e.createdAt != null)
                              Text(
                                e.createdAt!.formattedDateForUIWithTime,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              )
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(e.priceText),
                            //TODO: ADD DISTANCE TO BRANCH
                          ],
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (product == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: IColors.primary),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Minimum Price",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "Price Found At: ${product?.minPriceModel?.branch?.name}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                if (product?.createdAt != null)
                  Text(
                    product!.createdAt!.formattedDateForUIWithTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  )
              ],
            ),
            const Spacer(),
            Text(
              product?.minPriceText ?? "no price",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward_ios,
              ),
            )
          ],
        ),
      ),
    );
  }
}
