import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/controllers/auth_controller.dart';
import 'package:ucuzunu_bul/core/helpers/custom_logger.dart';
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';
import 'package:ucuzunu_bul/core/utilities/extensions.dart';
import 'package:ucuzunu_bul/models/support_ticket_model.dart';
import 'package:ucuzunu_bul/services/supabase_database_service.dart';

class SupportFormFields {
  String? subject;
  String? title;
  String? message;
}

class SupportPage extends StatefulWidget {
  static const route = "/support";
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  late final GlobalKey<FormState> _formKey;
  late final SupportFormFields _formFields;
  @override
  void initState() {
    _formFields = SupportFormFields();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowBackButton: false,
      appBar: AppBar(
        title: const Text('Destek ve Şikayet'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomInputArea(
                textField: DropdownButtonFormField(
                  value: null,
                  validator: (value) => (value ?? "").isNotEmpty
                      ? null
                      : "Lütfen bir seçim yapınız",
                  hint: const Text("Konu"),
                  onSaved: (s) => _formFields.subject = s,
                  items: const [
                    DropdownMenuItem(
                      value: "sikayet",
                      child: Text("Şikayet"),
                    ),
                    DropdownMenuItem(
                      value: "destek",
                      child: Text("Destek"),
                    ),
                  ],
                  onChanged: (s) {},
                ),
              ),
              CustomInputArea(
                textField: TextFormField(
                  validator: (value) =>
                      (value ?? "").isNotEmpty ? null : "Başlık boş olamaz",
                  decoration: const InputDecoration(
                    hintText: "Başlık",
                  ),
                  onSaved: (s) => _formFields.title = s,
                ),
              ),
              CustomInputArea(
                height: 240,
                textField: TextFormField(
                  maxLines: 20,
                  minLines: 10,
                  onSaved: (s) => _formFields.message = s,
                  decoration: const InputDecoration(
                    hintText: "Açıklama",
                  ),
                  validator: (value) => (value ?? "").isNotEmpty
                      ? null
                      : "Lütfen bir açıklama giriniz",
                ),
              ),
              CustomShapedButton(
                text: "Gönder",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      context.loaderOverlay.show();

                      await Get.find<SupabaseDatabaseService>()
                          .createSupportTicket(SupportTicketModel(
                        title: _formFields.title,
                        subject: _formFields.subject,
                        message: _formFields.message,
                        userId: Get.find<AuthController>().user?.id,
                      ));
                      // ignore: use_build_context_synchronously
                      context.showSuccessSnackBar(
                          message: "Destek Talebiniz Alındı");
                      Get.back();
                    } on PlatformException catch (_) {
                      DialogHelper.showCustomDialog(
                        context: context,
                        icon:
                            Image.asset("assets/images/error-dialog-image.png"),
                        title: "Mail Gönderilemedi",
                        description:
                            "Cihazınızda Mail Uygulaması Bulunmuyor.\n\n ${AppConstants.supportEmail} adresine mail atabilirsiniz.",
                      );
                    } catch (e) {
                      printE(e);
                      DialogHelper.showCustomDialog(
                          context: context,
                          icon: Image.asset(
                              "assets/images/error-dialog-image.png"),
                          title: "Mail Gönderilemedi",
                          description: "Bilinmeyen bir hata oluştu");
                    } finally {
                      context.loaderOverlay.hide();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
