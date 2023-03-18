import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:ucuzunu_bul/components/custom_input_area.dart';
import 'package:ucuzunu_bul/components/custom_scaffold.dart';
import 'package:ucuzunu_bul/components/custom_shaped_button.dart';
import 'package:ucuzunu_bul/core/utilities/app_constants.dart';
import 'package:ucuzunu_bul/core/utilities/dialog_helper.dart';

class SupportFormFields {
  String? subject;
  String? project;
  String? description;
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
                      (value ?? "").isNotEmpty ? null : "Proje Adınızı Giriniz",
                  decoration: const InputDecoration(
                    hintText: "Projeniz",
                  ),
                  onSaved: (s) => _formFields.project = s,
                ),
              ),
              CustomInputArea(
                height: 240,
                textField: TextFormField(
                  maxLines: 20,
                  minLines: 10,
                  onSaved: (s) => _formFields.description = s,
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
                      final Email email = Email(
                        body: _formFields.description!,
                        subject:
                            "Proje: ${_formFields.project}\n${_formFields.subject!}",
                        recipients: [AppConstants.supportEmail],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email);
                    } on PlatformException catch (_) {
                      DialogHelper.showCustomDialog(
                        context: context,
                        icon:
                            Image.asset("assets/images/error-dialog-image.png"),
                        title: "Mail Gönderilemedi",
                        description:
                            "Cihazınızda Mail Uygulaması Bulunmuyor.\n\n ${AppConstants.supportEmail} adresine mail atabilirsiniz.",
                      );
                    } catch (_) {
                      DialogHelper.showCustomDialog(
                          context: context,
                          icon: Image.asset(
                              "assets/images/error-dialog-image.png"),
                          title: "Mail Gönderilemedi",
                          description: "Bilinmeyen bir hata oluştu");
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
