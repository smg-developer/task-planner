import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class AddTask extends StatefulWidget {
  final index;
  final id;
  final title;
  final desc;
  final isComplete;
  const AddTask({
    super.key,
    this.id = '',
    this.index = -1,
    this.title = '',
    this.desc = '',
    this.isComplete = false,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isTaskComplete = false;
  var taskId = DateTime.now().toString();

  //TaskPriority _selectedPriority = TaskPriority.Low;
  _submitTask() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter all fields')));
    } else {
      Task task = Task(
        id: taskId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        //priority: _selectedPriority,
        isCompleted: isTaskComplete,
      );
      Navigator.of(context).pop([task, widget.index]);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != -1) {
      taskId = widget.id;
      _titleController.text = widget.title;
      _descriptionController.text = widget.desc;
      isTaskComplete = widget.isComplete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hint: Text('Do the chores'),
                label: Text('Task Title'),
              ),
              maxLength: 80,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hint: Text('Cleaning the rooms, laundry, etc.'),
                label: Text('Task Description'),
              ),
              maxLength: 80,
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     DropdownMenu(
            //       initialSelection: _selectedPriority.name,
            //       alignmentOffset: Offset.fromDirection(0),
            //       hintText: 'Priority',
            //       dropdownMenuEntries: TaskPriority.values.map((e) {
            //         return DropdownMenuEntry(label: e.name, value: e.name);
            //       }).toList(),
            //       onSelected: (value) {
            //         TaskPriority.values.firstWhere((item) {
            //           if (item.name == value) {
            //             _selectedPriority = item;
            //             return true;
            //           }
            //           return false;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  style: ButtonStyle(
                    //textStyle: Theme.of(context).textTheme!.copyWith(),
                  ),
                  onPressed: _submitTask,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
