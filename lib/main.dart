import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ucuzunu_bul/core/theme/app_theme.dart';
import 'package:ucuzunu_bul/routes/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'root_binding.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://pqerqhikadmusqtzfmoa.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxZXJxaGlrYWRtdXNxdHpmbW9hIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzEwMTExNjQsImV4cCI6MTk4NjU4NzE2NH0.mDLDAjNDmIuUaR8vj5kGmM7zq_Wmz4RLaA_GPG5FSEQ",
  );
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
