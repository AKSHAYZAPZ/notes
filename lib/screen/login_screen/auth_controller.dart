import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/screen/home_screen/home_screen.dart';
import 'package:notes_app/screen/login_screen/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;

  late Rx<User?> firebaseUser;

  var userController = TextEditingController();
  var phoneController = TextEditingController();
   final otpController = List.generate(6, (index) => TextEditingController());

  // final otpController = List.generate(6, (index) => TextEditingController());
  var otpNumber = ''.obs;
  var isOtpSent = false.obs;
  String verificationID = '';

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      print("not login");
      Get.offAll(() => LoginScreen());
    } else {
      print("login");

      Get.offAll(() => HomeScreen());
    }
  }

  sentOtp() async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+91${phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', 'Problem when send the OTP');
      },
      codeSent: (String verificationId, [int? resendtoken]) {
        verificationID = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  verifyOtp() async {
    String otp = '';
    otp = otpNumber.value;

    // for (var i = 0; i < otpController.length; i++) {
    //   otp += otpController[i].text;
    // }

    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp);

      final User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        print('otp ${otp}');
        print("success");
        print("useridd----==>${user.uid}");
         Get.snackbar('Success', 'Logging in',colorText: ColorConstant.redcolor);
      } else {
        print("fail");
        print('otp ${otp}');
      }
    } catch (e) {
      print('otp ${otp}');
      Get.snackbar('oops..', 'Verfication failed',colorText: ColorConstant.redcolor);
    }
  }

  signOut() async {
    auth.signOut();
    userController.text = '';
    phoneController.text = '';
    isOtpSent.value = false;
    otpNumber.value = "";
    // for (var i = 0; i < otpController.length; i++) {
    //   otpController[i].text = '';
    // }
  }
}