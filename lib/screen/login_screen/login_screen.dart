import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/screen/login_screen/auth_controller.dart';
import 'package:notes_app/screen/login_screen/login_controller.dart';
import 'package:notes_app/screen/otp_screen/otp_screen.dart';
import '../../consts/color_constants.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());
  TextEditingController numController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final AuthController authController = AuthController.instance;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage(AssetImages.splashImg),
                      // ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Enter your login details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.black,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: authController.phoneController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Phone number',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorConstant.black,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () async{
                    await authController.sentOtp();
                  Get.to(() =>  OtpScreen());
                  },
                  child: CustomButton('Send OTP',MediaQuery.of(context).size.width * 0.75, 45, ColorConstant.white,
                      ColorConstant.logoblue, 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
