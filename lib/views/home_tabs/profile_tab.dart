import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/views/edit_profile_page.dart';
import 'package:ucuzunu_bul/views/login_page.dart';
import 'package:ucuzunu_bul/views/support_page.dart';

import '../../components/custom_avatar_container.dart';

class ProfileTab extends GetView<AuthController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      title: "Profile",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAvatarContainer(
                  profileImageUrl: controller.user?.imageUrl,
                  radius: 130,
                  isEditable: true,
                  onImagePicked: (file) async {
                    await controller.updateProfileImage(file);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  controller.user?.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildListItem(
                      context: context,
                      icon: const Icon(Icons.person),
                      title: "Profile Settings",
                      onTap: () => Get.toNamed(EditProfilePage.route),
                    ),
                    _buildListItem(
                      context: context,
                      icon: const Icon(Icons.support_agent),
                      title: "Support",
                      onTap: () => Get.toNamed(SupportPage.route),
                    ),
                    _buildListItem(
                      context: context,
                      icon: const Icon(Icons.logout),
                      title: "Çıkış Yap",
                      onTap: () => Get.find<AuthController>().logout().then(
                            (value) => Get.offAllNamed(LoginPage.route),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      {required BuildContext context,
      required Widget icon,
      required String title,
      VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minVerticalPadding: 16,
      leading: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffF7F6F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: icon,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
