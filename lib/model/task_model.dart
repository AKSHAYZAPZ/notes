class Task {
  final String id;
  final String userId;
  String? title;
  DateTime? time;

  String? description;

  final bool isCompleted;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
  });
}