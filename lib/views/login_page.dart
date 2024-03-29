import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/views/forgot_password_page.dart';
import 'package:ucuzunu_bul/views/home_page.dart';
import 'package:ucuzunu_bul/views/register_page.dart';
import '../components/logo_component.dart';

class LoginPage extends StatefulWidget {
  static const route = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  String? mail;
  String? password;

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    Get.find<AuthController>().currentUser().then((value) {
      if (value != null) {}
    });
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
              const LogoContainer(),
              const SizedBox(height: 16),
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
                  initialValue: kDebugMode ? "onurrckrr@gmail.com" : null,
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
                  initialValue: kDebugMode ? "12345678" : null,
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
                        .login(mail!, password!)
                        .then((value) {
                      if (value != null) {
                        Get.offAllNamed(HomePage.route);
                      }
                    });

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                text: "Login",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.toNamed(RegisterPage.route),
                    child: const Text("Create A New Account"),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(ForgotPasswordPage.route),
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
