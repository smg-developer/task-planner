import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:task_manager/models/task.dart';
import 'package:http/http.dart' as http;

class TaskProviderNotifier extends StateNotifier<List<Task>> {
  //final List<Task> taskList = [];
  TaskProviderNotifier() : super([]);

  Future<List<Task>> fetchTasks() async {
    final url = Uri.https(
      "taskplanner-d4390-default-rtdb.firebaseio.com",
      "task-planner.json",
    );

    try {
      final resp = await http.get(url);

      if (resp.statusCode > 400) {
        throw Error();
      }

      if (resp.body == 'null' || resp.body == null) {
        return [];
      }

      print(json.decode(resp.body));

      final Map<String, dynamic> listData = json.decode(resp.body);
      final List<Task> tasksList = [];
      for (final item in listData.entries) {
        Task ts = Task(
          id: item.key,
          title: item.value['title'],
          description: item.value['description'],
          isCompleted: item.value['completed'],
        );
        tasksList.add(ts);
      }

      return tasksList;
    } catch (error) {
      print(error);
      return [];
    }
  }

  updateState(value) {
    state = value;
  }

  addTask(Task task) async {
    final url = Uri.https(
      "taskplanner-d4390-default-rtdb.firebaseio.com",
      "task-planner.json",
    );

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'completed': task.isCompleted,
      }),
    );

    state = [...state, task];
  }

  editTask(Task task) async {
    final url = Uri.https(
      "taskplanner-d4390-default-rtdb.firebaseio.com",
      "task-planner/${task.id}.json",
    );

    final resp = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'completed': task.isCompleted,
      }),
    );

    if (resp.statusCode == 200) {
      // Replace the old task with the new one
      state = [
        for (final t in state)
          if (t.id == task.id) task else t,
      ];
    }
  }

  changeTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;

    final url = Uri.https(
      "taskplanner-d4390-default-rtdb.firebaseio.com",
      "task-planner/${task.id}.json",
    );

    final resp = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': task.isCompleted}),
    );

    state = [...state];
  }

  deleteTask(Task task) async {
    final url = Uri.https(
      "taskplanner-d4390-default-rtdb.firebaseio.com",
      "task-planner/${task.id}.json",
    );

    final resp = await http.delete(url);

    state.removeWhere((item) => item.id == task.id);
    state = [...state];
    //state = newList;
  }
}

final taskProvider = StateNotifierProvider<TaskProviderNotifier, List<Task>>((
  ref,
) {
  return TaskProviderNotifier();
});
