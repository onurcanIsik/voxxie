import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/components/auth/btn_widget.dart';
import 'package:voxxie/core/components/auth/txt_form.widget.dart';

class SendMailPage extends StatelessWidget {
  final String ownerMail;
  SendMailPage({
    super.key,
    required this.ownerMail,
  });

  final TextEditingController headerController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TxtFormWidget(
                topPad: 70,
                hintTxt: 'Mail Header',
                controller: headerController,
                validatorTxt: (value) {
                  if (value!.isEmpty) {
                    return 'Cannot be blank';
                  }
                  return null;
                },
                isVisible: false,
                isObscure: false,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: TextFormField(
                  controller: bodyController,
                  textAlign: TextAlign.start,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be blank';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 30,
                    ),
                    hintText: "Body",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: btnColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: btnColor),
                    ),
                  ),
                ),
              ),
              BtnWidget(
                topPdng: 30,
                btnHeight: 40,
                btnText: 'Send',
                btnWidth: 100,
                btnFunc: () async {
                  if (formKey.currentState!.validate()) {
                    final Email email = Email(
                      body: bodyController.text,
                      subject: headerController.text,
                      recipients: [ownerMail],
                      isHTML: false,
                    );
                    await FlutterEmailSender.send(email).whenComplete(() {
                      return QuickAlert.show(
                          context: context, type: QuickAlertType.success);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: logoColor,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Send Mail',
        style: GoogleFonts.fredoka(
          color: Colors.white,
        ),
      ),
    );
  }
}
