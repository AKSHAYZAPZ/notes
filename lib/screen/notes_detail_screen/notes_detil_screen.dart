import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/screen/home_screen/task_controller.dart';
import 'package:notes_app/screen/notes_detail_screen/edit_contoller.dart';

class NoteDetailScreen extends StatelessWidget {
  NoteDetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.taskId});

  final String title;
  final String description;
  final String taskId;

 

  @override
  Widget build(BuildContext context) {
    Editcontroller editcontroller =
      Get.put(Editcontroller(description: description, title: title)); 
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      label: Text('Title'), border: OutlineInputBorder()),
                  controller: editcontroller.titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 22,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    // label: Text('Description'),
                    border: InputBorder.none,
                  ),
                  controller: editcontroller.descriptionController,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
TaskController taskController = Get.find();
                taskController.updateTask(taskId, editcontroller.titleController.text,
                   editcontroller .descriptionController.text, DateTime.now());
                Get.back();
          },
          child: CustomButton(
              'Save Changes',
              MediaQuery.of(context).size.width * 0.6,
              45,
              ColorConstant.white,
              ColorConstant.logoblue,
              14),
        ),
      ),
    );
  }
}
