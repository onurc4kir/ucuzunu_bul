import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/logo_component.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/views/home_page.dart';
import 'package:ucuzunu_bul/views/login_page.dart';
import '../../../components/custom_scaffold.dart';

class OnboardPage extends StatefulWidget {
  static const route = "/onboard";
  const OnboardPage({Key? key}) : super(key: key);

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  @override
  void initState() {
    Get.find<AuthController>().currentUser().then((value) {
      if (value != null) {
        Get.toNamed(HomePage.route);
      } else {
        Get.toNamed(LoginPage.route);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      useSafeArea: false,
      isShowBackButton: false,
      contentPadding: EdgeInsets.zero,
      bgColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Spacer(),
            LogoContainer(),
            SizedBox(height: 32),
            CupertinoActivityIndicator(radius: 18),
            Spacer(),
            Text(
              'VERSION 1.0.0',
              style: TextStyle(color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
