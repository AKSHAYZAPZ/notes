import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/consts/color_constants.dart';
import 'package:notes_app/consts/image_constants.dart';
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String userId = _authController.firebaseUser.value?.uid ?? '';
    print(userId);
    return Scaffold(
      backgroundColor: ColorConstant.adContainer,
      appBar: AppBar(
        backgroundColor: ColorConstant.logoblue,
        title: const Text(
          'Notes',
          style: TextStyle(color: ColorConstant.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showLogout(context);
              },
              icon: const Icon(
                Icons.logout,
                color: ColorConstant.white,
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                child: Row(
                  children: [
                    SizedBox(
                      height: 65,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            _taskController.searchTasks(userId, value);
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(7),
                              hintText: 'Search',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: ColorConstant.blacklite,
                              ),
                              hintStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.sort),
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
              ),
              SingleChildScrollView(
                child: Obx(
                  () => _taskController.filteredAndSortedTasks.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Lottie.asset(AssetImages.loader,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6),
                              const Text(
                                "No tasks",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              _taskController.filteredAndSortedTasks.length,
                          itemBuilder: (context, index) {
                            Task task =
                                _taskController.filteredAndSortedTasks[index];
                            String times = DateFormat('dd-MM-yyyy hh:mm a')
                                .format(task.time!);
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
                                    title: Text(
                                      task.title!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.description!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: ColorConstant.blacklite,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          times,
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
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDelete(context, task, userId);
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
          _showAddTaskDialog(userId);
        },
      ),
    );
  }

  void _showAddTaskDialog(String userId) {
    TextEditingController taskController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Get.defaultDialog(
      title: 'Add Note',
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: taskController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 184, 181, 181)), // Change border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 184, 181, 181)), // Change border color here
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                   textCapitalization: TextCapitalization.words,
                  minLines: 6,
                  maxLines: 6,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Note',
                    isDense: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 184, 181, 181)), // Change border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 184, 181, 181)), // Change border color here
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Note field can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(ColorConstant.logoblue)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _taskController.addTask(
                userId,
                taskController.text,
                descriptionController.text,
              );
              Get.back();
            }
          },
          child: const Text(
            'Add',
            style: TextStyle(color: ColorConstant.white),
          ),
        ),
      ],
    );
  }

  showLogout(context) {
    return showDialog(
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
                backgroundColor:
                    ColorConstant.logoblue, // Set the background color here
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
  }

  showDelete(context, task, userId) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure want to Delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    ColorConstant.logoblue, // Set the background color here
              ),
              onPressed: () async {
                _taskController.deleteTask(task.id, userId);
                Get.back();
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
  }
}
