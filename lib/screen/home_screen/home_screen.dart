import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/custom_widgets/custom_button.dart';
import 'package:notes_app/model/task_model.dart';
import 'package:notes_app/screen/home_screen/task_controller.dart';

import 'package:notes_app/screen/login_screen/auth_controller.dart';
import 'package:notes_app/screen/notes_detail_screen/notes_detil_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController _authController = AuthController.instance;
  final TaskController _taskController = Get.put(TaskController());
  // AuthController authController = Get.find<AuthController>();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
   TextEditingController taskController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String userId = _authController.firebaseUser.value?.uid ?? '';
    print(userId);
    return Scaffold(
      backgroundColor: ColorConstant.adContainer,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('Are you sure want to Logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant
                            .logoblue, // Set the background color here
                      ),
                      onPressed: () async {
                        _authController.signOut();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: ColorConstant.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        backgroundColor: ColorConstant.logoblue,
        title: const Text(
          'Notes',
          style: TextStyle(color: ColorConstant.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_sharp,
                color: ColorConstant.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: ColorConstant.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextFormField(
                  onChanged: (value) {
                    _taskController.searchTasks(userId, value);
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _taskController.sortTasks(userId, value);
                    print('Selected: $value');
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Text('Sort by name'),
                      ),
                      const PopupMenuItem<String>(
                        value: '2',
                        child: Text('Sort by time'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              child: Obx(
                 () =>
                 _taskController.filteredAndSortedTasks.isEmpty
                  ? const Center(
                      child: Text("No tasks"),
                    )
                  :
                   ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _taskController.filteredAndSortedTasks.length,
                    itemBuilder: (context, index) {
                      Task task =
                            _taskController.filteredAndSortedTasks[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => NoteDetailScreen(
                                  title: _taskController
                                      .filteredAndSortedTasks[index].title!,
                                  description: _taskController
                                      .filteredAndSortedTasks[index]
                                      .description!,
                                  taskId: _taskController
                                      .filteredAndSortedTasks[index].id,
                                ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 6, top: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(1, 1),
                                )
                              ],
                            ),
                            child: ListTile(
                              title:  Text(
                                task.title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.description!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorConstant.blacklite,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    task.time!.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorConstant.blacklite,
                                    ),
                                  )
                                ],
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    color: ColorConstant.greyType,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: const Text(
                                                'Are you sure want to Delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text('No'),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: ColorConstant
                                                      .logoblue, // Set the background color here
                                                ),
                                                onPressed: () async {
                                                _taskController.deleteTask(task.id, userId);
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    color: ColorConstant.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: ColorConstant.redcolor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstant.logoblue,
        label: const Text(
          'Add Note ',
          style: TextStyle(
            color: ColorConstant.white,
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Note field can't empty";
                          } else {
                            return null;
                          }
                        },
                        controller: titleTextController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 12),
                            labelText: 'Title',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 208,
                                      208)), // Change border color here
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Color.fromARGB(255, 212, 208, 208)))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        minLines: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Note field can't be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: descriptionTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 13, vertical: 12),
                          labelText: 'Note',
                          hintText: 'Please type your note here',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 208,
                                    208)), // Change border color here
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 208,
                                    208)), // Change border color here
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Clicked');
                              _taskController.addTask(
              userId,
              taskController.text,
              descriptionController.text,
            );
            Get.back();
                          // if (formKey.currentState != null &&
                          //     formKey.currentState!.validate()) {
                          //   formKey.currentState!.save();
                          //   dashBoardController.addWorkToData(
                          //       quantityTextController.text, context
                          //   );
                          // }
                        },
                        child: CustomButton(
                            'Save Note',
                            MediaQuery.of(context).size.width * 0.6,
                            45,
                            ColorConstant.white,
                            ColorConstant.logoblue,
                            14),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
