import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Editcontroller extends GetxController{

final title;

final description;

Editcontroller({required this.description,required this.title});

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();



  @override
  void onReady() {
   titleController.text = title;
descriptionController.text = description;
    super.onReady();
  }
}