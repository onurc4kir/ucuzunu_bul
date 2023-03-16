import 'package:flutter/material.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      isShowBackButton: false,
      title: "Rewards",
      body: Text("Home"),
    );
  }
}
