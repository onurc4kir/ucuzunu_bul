import 'package:flutter/material.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      isShowBackButton: false,
      title: "ProfileTab",
      body: Text("ProfileTab"),
    );
  }
}
