import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/screen/login_screen/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text('Verify your number ', style: TextStyle()),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Enter your OTP code here!',
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      height: 50,
                      width: 35,
                      child: TextFormField(
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        controller: authController.otpController[index],
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length == 1 && index <= 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isNotEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: const InputDecoration(
                            counterText: '', hintText: ''),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    authController.otpNumber.value = '';
                    for (int i = 0; i < 6; i++) {
                      authController.otpNumber.value +=
                          authController.otpController[i].text;

                      authController.verifyOtp();
                    }
                  },
                  child: CustomButton(
                    'Verify',
                    MediaQuery.of(context).size.width * 0.75,
                    45,
                    ColorConstant.white,
                    ColorConstant.logoblue,
                    18,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't get the reset OTP? "),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Resend',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
