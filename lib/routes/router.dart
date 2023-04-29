import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:ucuzunu_bul/controllers/geolocator_controller.dart';
import 'package:ucuzunu_bul/controllers/home_controller.dart';
import 'package:ucuzunu_bul/controllers/home_explore_controller.dart';
import 'package:ucuzunu_bul/controllers/product_controller.dart';
import 'package:ucuzunu_bul/controllers/rewards_controller.dart';
import 'package:ucuzunu_bul/controllers/search_controller.dart';
import 'package:ucuzunu_bul/controllers/store_controller.dart';
import 'package:ucuzunu_bul/views/edit_profile_page.dart';
import 'package:ucuzunu_bul/views/forgot_password_page.dart';
import 'package:ucuzunu_bul/views/home_page.dart';
import 'package:ucuzunu_bul/views/login_page.dart';
import 'package:ucuzunu_bul/views/onboard_page.dart';
import 'package:ucuzunu_bul/views/product_detail_page.dart';
import 'package:ucuzunu_bul/views/purchase_history_page.dart';
import 'package:ucuzunu_bul/views/register_page.dart';
import 'package:ucuzunu_bul/views/store_detail_page.dart';
import 'package:ucuzunu_bul/views/support_page.dart';

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
    GetPage(
      name: RegisterPage.route,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: SupportPage.route,
      page: () => const SupportPage(),
    ),
    GetPage(
      name: EditProfilePage.route,
      page: () => const EditProfilePage(),
    ),
    GetPage(
      name: PurchaseHistoryPage.route,
      page: () => const PurchaseHistoryPage(),
    ),
    GetPage(
      name: "${ProductDetailPage.route}/:productId",
      page: () => const ProductDetailPage(),
    ),
    GetPage(
      name: "${StoreDetailPage.route}/:storeId",
      page: () => const StoreDetailPage(),
    ),
    GetPage(
      name: HomePage.route,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put(GeolocatorController());
        Get.put(ProductController());
        Get.put(RewardsController());
        Get.put(StoreController());
        Get.put(HomeController());
        Get.put(HomeExploreController());
        Get.put(SearchController());
      }),
    ),
  ];
}
