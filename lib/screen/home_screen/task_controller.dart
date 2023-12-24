import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/model/task_model.dart';
import 'package:notes_app/screen/login_screen/auth_controller.dart';

class TaskController extends GetxController {
  static TaskController instance = Get.find();
  late Box<Task> taskBox;

  final AuthController _authController = AuthController.instance;
  var searchQuery = "".obs;
  var sortCriteria = "".obs;

  List<Task> filteredAndSortedTasks = <Task>[].obs;
  @override
  void onInit() {
    super.onInit();
    String userId = _authController.firebaseUser.value?.uid ?? '';

    taskBox = Hive.box<Task>('taskBox');

    filteredAndSortedTasks.addAll(getTasksByUserId(userId));

    print(filteredAndSortedTasks);
  }

//getting task of user
  List<Task> getTasksByUserId(String userId) {
    print(userId);
    return taskBox.values.where((task) {
      print(task.userId);
      return task.userId == userId;
    }).toList(growable: false);
  }

  void addTask(String userId, String title, String description) {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    final task = Task(
      id: taskId,
      userId: userId,
      title: title,
      description: description,
      time: DateTime.now(),
      isCompleted: false,
    );
    taskBox.put(taskId, task);

    filteredAndSortedTasks.clear();
    filteredAndSortedTasks.addAll(getTasksByUserId(userId));
  }

  void deleteTask(String taskId, String userId) {
    taskBox.delete(taskId);
    filteredAndSortedTasks.clear();
    filteredAndSortedTasks.addAll(getTasksByUserId(userId));
  }

  void updateTask(
      String taskId, String newTitle, String newDescription, DateTime newTime) {
    Task? taskToUpdate = taskBox.get(taskId);

    if (taskToUpdate != null) {
      taskToUpdate.title = newTitle;
      taskToUpdate.description = newDescription;
      taskToUpdate.time = newTime;

      taskBox.put(taskId, taskToUpdate);
      filteredAndSortedTasks.clear();
      filteredAndSortedTasks.addAll(getTasksByUserId(taskToUpdate.userId));

      print(filteredAndSortedTasks);

      update();
    }
  }

//sorting based on time and name
  void sortTasks(String userId, String sortCriteria) {
    filteredAndSortedTasks
        .assignAll(_getSortedTasks(userId, sortCriteria, searchQuery.value));
    update();
  }

//sorting based on searckey
  void searchTasks(String userId, String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredAndSortedTasks
          .assignAll(_getSortedTasks(userId, sortCriteria.value, ''));
    } else {
      filteredAndSortedTasks
          .assignAll(_getSortedTasks(userId, sortCriteria.value, query));
    }
    update();
  }

  List<Task> _getSortedTasks(
      String userId, String sortCriteria, String searchQuery) {
    List<Task> sortedTasks = getTasksByUserId(userId);

    if (sortCriteria == '1') {
      sortedTasks.sort((a, b) => a.title!.compareTo(b.title!));
    } else if (sortCriteria == '2') {
      sortedTasks.sort((a, b) => b.time!.compareTo(a.time!));
    }

    return sortedTasks.where((task) {
      return task.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.description!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}