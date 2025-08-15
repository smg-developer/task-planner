import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> taskList;
  const TaskList({
    super.key,
    required this.taskList,
    required this.editTask,
    required this.deleteTask,
    required this.changeTaskStatus,
  });

  final void Function(Task task, int index) editTask;
  final void Function(Task task) deleteTask;
  final void Function(Task task) changeTaskStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        Task task = taskList[index];
        // Color pColor = Colors.blue;
        // if (task.priority == TaskPriority.High) {
        //   pColor = Colors.red;
        // }
        // if (task.priority == TaskPriority.Medium) {
        //   pColor = Colors.green;
        // }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 0.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: ListTile(
              onTap: () {
                editTask(task, index);
              },
              leading: Checkbox(
                //  checkColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                value: task.isCompleted,
                onChanged: (val) {
                  changeTaskStatus(task);
                },
              ),
              title: Text(task.title),
              subtitle: Text(task.description),

              //trailing: Row(),
              // trailing: Expanded(
              //   child: Row(
              //     children: [
              //       IconButton.outlined(
              //         onPressed: () {},
              //         icon: Icon(Icons.edit),
              //         iconSize: 16,
              //       ),
              //       SizedBox(width: 5),
              //       IconButton.outlined(
              //         onPressed: () {},
              //         icon: Icon(Icons.delete),
              //         iconSize: 16,
              //       ),
              //     ],
              //   ),
              // ),
              trailing: IconButton(
                onPressed: () {
                  deleteTask(task);
                  //dialog.
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        );
      },
    );
  }
}
