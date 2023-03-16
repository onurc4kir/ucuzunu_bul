import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/home_controller.dart';
import 'package:ucuzunu_bul/core/theme/colors.style.dart';

class HomePage extends StatelessWidget {
  static const route = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: IColors.primary,
        onPressed: () async {
          try {
            final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666', 'Cancel', true, ScanMode.QR);
            print(barcodeScanRes);
          } catch (e) {
            print(e);
          }
        },
        tooltip: 'Scan a product',
        elevation: 2.0,
        child: const Icon(
          Icons.barcode_reader,
          color: Colors.black87,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavigationBarItem(
              tab: HomePageTabs.home,
              icon: Icons.home,
              label: "Home",
            ),
            _buildBottomNavigationBarItem(
              tab: HomePageTabs.rewards,
              icon: Icons.redeem,
              label: "Rewards",
            ),
            const Spacer(),
            _buildBottomNavigationBarItem(
              tab: HomePageTabs.search,
              icon: Icons.search,
              label: "Search",
            ),
            _buildBottomNavigationBarItem(
              tab: HomePageTabs.profile,
              icon: Icons.person,
              label: "Profile",
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBottomNavigationBarItem({
    required HomePageTabs tab,
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          Get.find<HomeController>().changeTab(tab);
        },
        splashRadius: 22,
        icon: Obx(
          () => Icon(
            icon,
            color: Get.find<HomeController>().selectedTab == tab
                ? IColors.primary
                : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final homeController = Get.find<HomeController>();
    return Obx(() => homeController.tabs[homeController.selectedTab]!);
  }
}
