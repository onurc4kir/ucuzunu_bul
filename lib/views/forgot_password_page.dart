import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/components/logo_component.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const route = "/forgot-password";
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String? _username;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Reset Password",
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomShapedButton(
          text: "Send Renewal Code",
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Get.find<AuthController>()
                  .requestPasswordReset(_username!)
                  .then((value) {
                if (value) {
                  DialogHelper.showCustomDialog(
                    context: context,
                    icon: Image.asset("assets/images/in-progress.png"),
                    title: "Reset Password Request",
                    description:
                        "Your request has been sent to the server. Please check your email for the renewal code.",
                    okButtonOnTap: () => Navigator.of(context).pop(),
                    okButtonText: "Okey",
                  );
                }
              });
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LogoContainer(),
              CustomInputArea(
                textField: TextFormField(
                  onSaved: (name) {
                    _username = name;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Username/Client Code'),
                  validator: (value) =>
                      value!.isEmpty ? "Required Field" : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
