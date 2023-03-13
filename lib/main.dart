import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ucuzunu_bul/core/theme/app_theme.dart';
import 'package:ucuzunu_bul/routes/router.dart';

import 'root_binding.dart';

main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: GetMaterialApp(
        theme: appThemeData,
        debugShowCheckedModeBanner: true,
        getPages: GetPages.pages,
        unknownRoute: GetPage(
          name: '/notfound',
          page: () => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        ),
        initialRoute: GetPages.initialRoute,
        initialBinding: RootBinding(),
        locale: const Locale('en'),
        supportedLocales: const [
          Locale('en'),
        ],
      ),
    );
  }
}
