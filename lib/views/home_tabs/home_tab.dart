import 'package:flutter/material.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      isShowBackButton: false,
      title: "Home",
      body: Text("Home"),
    );
  }
}
