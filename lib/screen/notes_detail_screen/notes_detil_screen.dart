import 'package:flutter/material.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';

class NoteDetailScreen extends StatelessWidget {
  NoteDetailScreen({super.key, required this.title, required this.description, required this.taskId});

   final String title;
  final String description;
  final String taskId;


 

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController =
        TextEditingController(text: description);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  label: Text('Title'), border: OutlineInputBorder()),
              controller: titleController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
          maxLines: 10,
              decoration: const InputDecoration(
                  label: Text('description'), border: OutlineInputBorder()),
              controller: descriptionController,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomButton(
                'Save Changes',
                MediaQuery.of(context).size.width * 0.6,
                45,
                ColorConstant.white,
                ColorConstant.logoblue,
                14),
          ),
        ],
      ),
    );
  }
}
