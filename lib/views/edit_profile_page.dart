import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';

class EditProfilePage extends StatefulWidget {
  static const String route = "/edit-profile";
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Edit Profile",
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              CustomInputArea(
                textField: TextFormField(
                  validator: (s) => s!.isEmpty ? "Name cannot be empty" : null,
                  onSaved: (s) => _authController.user?.name = s!,
                  initialValue: _authController.user?.name,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ),
              CustomInputArea(
                textField: TextFormField(
                  initialValue: _authController.user?.mail,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Mail",
                  ),
                ),
              ),
              CustomShapedButton(
                text: "Save",
                onPressed: () async {
                  await _authController.updateProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
