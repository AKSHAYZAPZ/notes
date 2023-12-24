import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_app/consts/image_constants.dart';
import 'package:notes_app/controller/network_controller.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/screen/login_screen/auth_controller.dart';
import 'package:notes_app/screen/otp_screen/otp_screen.dart';
import '../../consts/color_constants.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});


  final NetworkController networkController = Get.put(NetworkController());
final GlobalKey<FormState> formKey = GlobalKey<FormState>(); 


  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
           if(networkController.isConnected.value){ 
   final AuthController authController = AuthController.instance;
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.35,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AssetImages.otpScrnImg),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                          fontWeight: FontWeight.normal,
                          color: ColorConstant.black,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                           validator: (value) {
                        if (value == null || value == "") {
                          return "Please enter your number";
                        } else if (value.length != 10) {
                          return "Invalid phone number";
                        }
                        return null;
                      },
                          keyboardType: TextInputType.number,
                          controller: authController.phoneController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
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
                           if (formKey.currentState!.validate()) {
                        await authController.sentOtp();
                        Get.to(() => OtpScreen());
                      }
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
          ),
        );
      }else{
        return networkController.noDataImage(context);
      }
      }
    );

  }
}
