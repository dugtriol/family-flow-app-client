// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/todo_bloc.dart';
// import 'package:todo_api/todo_api.dart';

// class TodoEditDialog extends StatefulWidget {
//   const TodoEditDialog({super.key, required this.todo});

//   final TodoItem todo;

//   @override
//   State<TodoEditDialog> createState() => _TodoEditDialogState();
// }

// class _TodoEditDialogState extends State<TodoEditDialog> {
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   late DateTime _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.todo.title);
//     _descriptionController = TextEditingController(
//       text: widget.todo.description,
//     );
//     _selectedDate = widget.todo.deadline;
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final todoBloc = context.read<TodoBloc>();

//     return AlertDialog(
//       title: Row(
//         children: [
//           const Icon(Icons.edit, color: Colors.blue),
//           const SizedBox(width: 8),
//           const Text(
//             'Edit Todo',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(
//               controller: _titleController,
//               label: 'Title',
//               icon: Icons.title,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _descriptionController,
//               label: 'Description',
//               icon: Icons.description,
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: () => _selectDate(context),
//               child: Row(
//                 children: [
//                   const Icon(Icons.calendar_today, color: Colors.blue),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Deadline: ${_selectedDate.toLocal().toString().split(' ')[0]}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Закрыть диалог
//           },
//           child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             context.read<TodoBloc>().add(
//               TodoDeleteRequested(id: widget.todo.id),
//             );
//             Navigator.of(context).pop(); // Закрыть диалог
//           },
//           child: const Text('Delete'),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // Отправляем событие обновления задачи
//             context.read<TodoBloc>().add(
//               TodoUpdateRequested(
//                 id: widget.todo.id,
//                 title: _titleController.text,
//                 description: _descriptionController.text,
//                 status: widget.todo.status,
//                 deadline: _selectedDate,
//                 assignedTo: widget.todo.assignedTo,
//               ),
//             );
//             Navigator.of(context).pop(); // Закрыть диалог
//           },
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int maxLines = 1,
//   }) {
//     return TextField(
//       controller: controller,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.blue),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
