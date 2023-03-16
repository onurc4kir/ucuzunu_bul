import 'package:flutter/material.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      isShowBackButton: false,
      title: "SearchTab",
      body: Text("SearchTab"),
    );
  }
}
