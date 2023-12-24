import 'package:hive/hive.dart';
import 'package:notes_app/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 1;

  @override
  Task read(BinaryReader reader) {
    return Task(
      id: reader.read(),
      userId: reader.read(),
      title: reader.read(),
      description: reader.read(),
      time: reader.read(),
      isCompleted: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.write(obj.id);
    writer.write(obj.userId);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.time);

    writer.write(obj.isCompleted);
  }
}