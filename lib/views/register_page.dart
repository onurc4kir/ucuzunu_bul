import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';
import '../components/logo_component.dart';

class RegisterPage extends StatefulWidget {
  static const route = "/register";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final GlobalKey<FormState> _formKey;
  String? mail;
  String? password;

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const LogoContainer(),
              const SizedBox(height: 16),
              Text(
                "Register For The Cheapest Offers",
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              CustomInputArea(
                inputFieldPadding: EdgeInsets.zero,
                prefixWidgets: const [
                  Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ],
                textField: TextFormField(
                  readOnly: isLoading,
                  initialValue: null,
                  onSaved: (m) => mail = m,
                  validator: (m) =>
                      (m ?? "").isNotEmpty ? null : "Invalid email",
                  decoration: const InputDecoration(
                    hintText: 'Mail',
                  ),
                ),
              ),
              CustomInputArea(
                inputFieldPadding: EdgeInsets.zero,
                prefixWidgets: const [
                  Icon(
                    Icons.password_outlined,
                    color: Colors.grey,
                  ),
                ],
                suffixWidgets: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: obscurePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility_outlined),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ],
                textField: TextFormField(
                  readOnly: isLoading,
                  obscureText: obscurePassword,
                  initialValue: null,
                  onSaved: (pass) => password = pass,
                  validator: (p) => (p?.length ?? 0) >= 7
                      ? null
                      : "Password must be at least 7 characters long",
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
              CustomShapedButton(
                isLoading: isLoading,
                enabled: !isLoading,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await Get.find<AuthController>()
                        .registerWithMailAndPassword(
                      mail: mail!,
                      password: password!,
                    )
                        .then((value) {
                      if (value != null) {
                        DialogHelper.showCustomDialog(
                          context: context,
                          icon: const Icon(Icons.mail),
                          description:
                              "We sent a mail to $mail. Please confirm your mail.",
                        );
                      }
                    });

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                text: "Create An Account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
