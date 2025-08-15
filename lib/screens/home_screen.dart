import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/add_task.dart';
import 'package:task_manager/widgets/task_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Task>> _loadedItems;
  List<bool> selectedTabState = [true, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadedItems = ref.read(taskProvider.notifier).fetchTasks().then((value) {
      ref.read(taskProvider.notifier).updateState(value);
      return value;
    });
  }

  _deleteTask(Task task) {
    final dialog = AlertDialog(
      title: Text('Confirm'),
      content: Text('Are you sure you want to delete?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            ref.read(taskProvider.notifier).deleteTask(task);
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  _changeTaskStatus(Task task) {
    ref.read(taskProvider.notifier).changeTaskStatus(task);
  }

  _editTask(Task task, int index) async {
    final taskResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTask(
          index: index,
          id: task.id,
          title: task.title,
          desc: task.description,
          isComplete: task.isCompleted,
        ),
      ),
    );

    if (taskResult == null) {
      return;
    } else {
      Task savedTask = taskResult[0];
      int index = taskResult[1];

      if (index == -1) {
        //It's a new task added.

        ref.read(taskProvider.notifier).addTask(savedTask);
        print(savedTask.title);
        print(savedTask.isCompleted);
      } else {
        ref.read(taskProvider.notifier).editTask(savedTask);
        print(savedTask.title);
        print(savedTask.isCompleted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);
    final pendingTasks = taskList.where((taskItem) {
      return taskItem.isCompleted == false;
    }).toList();

    final completedTasks = taskList.where((taskItem) {
      return taskItem.isCompleted == true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('My Tasks')),
      body: taskList.isEmpty
          ? Center(child: Text('No tasks added!'))
          : Column(
              children: [
                ToggleButtons(
                  selectedColor: Theme.of(context).colorScheme.primary,
                  isSelected: selectedTabState,

                  // Example default selection
                  onPressed: (index) {
                    setState(() {
                      // Example: Single selection
                      for (int i = 0; i < selectedTabState.length; i++) {
                        selectedTabState[i] = (i == index);
                      }
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("All"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("To Do"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Done"),
                    ),
                  ],
                ),

                if (selectedTabState[0])
                  TaskList(
                    taskList: taskList,
                    editTask: _editTask,
                    deleteTask: _deleteTask,
                    changeTaskStatus: _changeTaskStatus,
                  )
                else if (selectedTabState[1])
                  TaskList(
                    taskList: pendingTasks,
                    editTask: _editTask,
                    deleteTask: _deleteTask,
                    changeTaskStatus: _changeTaskStatus,
                  )
                else
                  TaskList(
                    taskList: completedTasks,
                    editTask: _editTask,
                    deleteTask: _deleteTask,
                    changeTaskStatus: _changeTaskStatus,
                  ),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          final taskResult = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddTask()));

          if (taskResult == null) {
            return;
          } else {
            Task savedTask = taskResult[0];
            int index = taskResult[1];

            if (index == -1) {
              //It's a new task added.

              ref.read(taskProvider.notifier).addTask(savedTask);
              print(savedTask.title);
              print(savedTask.isCompleted);
            }
          }
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
