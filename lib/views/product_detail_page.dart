import 'package:flutter/material.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';

class ProductDetailPage extends StatelessWidget {
  static const String route = "/product-detail";
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Product Detail",
      body: Column(),
    );
  }
}
