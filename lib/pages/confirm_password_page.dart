import 'package:edu_vista_app/pages/login_page.dart';
import 'package:edu_vista_app/widgets/custom_elevated_button.dart';
import 'package:edu_vista_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordPage extends StatefulWidget {
  static const String id = 'ConfirmPasswordPage';
  const ConfirmPasswordPage({super.key, required email});

  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
            ),
            Form(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: '***********',
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hintText: '***********',
                    labelText: 'Confirm Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, LoginPage.id);
                    },
                    child: const Text(
                      'SUBMIT',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
