import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:ucuzunu_bul/views/forgot_password_page.dart';
import 'package:ucuzunu_bul/views/login_page.dart';
import 'package:ucuzunu_bul/views/onboard_page.dart';

abstract class GetPages {
  static const String initialRoute = OnboardPage.route;
  static const String unknownRoute = LoginPage.route;

  static final pages = <GetPage>[
    GetPage(
      name: OnboardPage.route,
      page: () => const OnboardPage(),
    ),
    GetPage(
      name: LoginPage.route,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: ForgotPasswordPage.route,
      page: () => const ForgotPasswordPage(),
    ),
  ];
}
