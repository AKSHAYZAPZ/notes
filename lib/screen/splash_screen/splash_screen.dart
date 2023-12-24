import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/screen/login_screen/auth_controller.dart';



class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(AssetImages.splashImg),
              // ),
            ),
          )
        ],
      ),
    );
  }
}
