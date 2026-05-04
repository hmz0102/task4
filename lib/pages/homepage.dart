// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemangement/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController taskcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  Image.asset(
                    "images/header.png",
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 25,
                    top: 70,
                    child: Text(
                      "TO DO",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 25,
                    top: 65,
                    child: InkWell(
                      onTap: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                      child: Image.asset(
                        isDark ? "images/light.png" : "images/dark.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    left: 20,
                    right: 20,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: taskcontroller,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Add a new task...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (taskcontroller.text.isNotEmpty) {
                                  context.read<TodoProvider>().addTask(
                                    taskcontroller.text,
                                  );
                                  taskcontroller.clear();
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task List Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  final tasks = todoProvider.filteredTasks;
                  return Column(
                    children: [
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            if (tasks.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Text(
                                  "No tasks found",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: tasks.length,
                                separatorBuilder: (context, index) =>
                                    Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return TaskItem(task: task);
                                },
                              ),
                            // Footer inside the card
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${todoProvider.activeTasksCount} items left",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      todoProvider.clearCompleted();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        Text(
                                          "Clear Completed",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Filter Buttons
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilterButton(
                                title: "All",
                                filter: TodoFilter.all,
                              ),
                              FilterButton(
                                title: "Active",
                                filter: TodoFilter.active,
                              ),
                              FilterButton(
                                title: "Completed",
                                filter: TodoFilter.completed,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            shape: BoxShape.circle,
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
