// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemangement/themes/themeprovider.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return ListTile(
      leading: InkWell(
        onTap: () => context.read<TodoProvider>().toggleTask(task.id),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade400),
            gradient: task.isDone
                ? LinearGradient(
                    colors: [Colors.blue.shade300, Colors.purple.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: task.isDone
              ? Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          color: task.isDone
              ? Colors.grey
              : (isDark ? Colors.white : Colors.black87),
          fontSize: 18,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<TodoProvider>().deleteTask(task.id);
        },
        icon: Icon(Icons.close, color: Colors.grey, size: 20),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final TodoFilter filter;

  const FilterButton({super.key, required this.title, required this.filter});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final isSelected = todoProvider.currentFilter == filter;
    return TextButton(
      onPressed: () => todoProvider.setFilter(filter),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

enum TodoFilter { all, active, completed }

class TaskModel {
  final String id;
  String title;
  bool isDone;
  TaskModel({required this.id, required this.title, this.isDone = false});
}

class TodoProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  TodoFilter currentFilter = TodoFilter.all;

  List<TaskModel> get filteredTasks {
    switch (currentFilter) {
      case TodoFilter.active:
        return tasks.where((t) => !t.isDone).toList();
      case TodoFilter.completed:
        return tasks.where((t) => t.isDone).toList();
      case TodoFilter.all:
      default:
        return tasks;
    }
  }

  int get activeTasksCount => tasks.where((t) => !t.isDone).length;

  void addTask(String title) {
    if (title.isNotEmpty) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      tasks.add(TaskModel(id: id, title: title));
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index].isDone = !tasks[index].isDone;
      notifyListeners();
    }
  }

  void setFilter(TodoFilter filter) {
    currentFilter = filter;
    notifyListeners();
  }

  void clearCompleted() {
    tasks.removeWhere((t) => t.isDone);
    notifyListeners();
  }
}
