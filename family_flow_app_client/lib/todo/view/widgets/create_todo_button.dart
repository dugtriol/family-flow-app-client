import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todo_bloc.dart';
import '../../../family/bloc/family_bloc.dart';

class CreateTodoButton extends StatelessWidget {
  const CreateTodoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateTodoDialog(context),
      child: const Icon(Icons.add),
    );
  }

  void _showCreateTodoDialog(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDeadline;
    String? selectedMemberId;

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Create Todo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<FamilyBloc, FamilyState>(
                      builder: (context, state) {
                        if (state is FamilyLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is FamilyLoadSuccess) {
                          return DropdownButtonFormField<String>(
                            value: selectedMemberId,
                            decoration: const InputDecoration(
                              labelText: 'Assign to',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            items: state.members.map((member) {
                              return DropdownMenuItem<String>(
                                value: member.id,
                                child: Text(member.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMemberId = value;
                              });
                            },
                          );
                        } else if (state is FamilyLoadFailure) {
                          return Text(
                            'Failed to load family members: ${state.error}',
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Deadline:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedDeadline != null
                              ? selectedDeadline!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : 'Select a date',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: dialogContext,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDeadline = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    final description = descriptionController.text;

                    if (selectedDeadline == null || selectedMemberId == null) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                      return;
                    }

                    // Преобразуем дату в UTC и форматируем в ISO 8601 с "Z"
                    final formattedDeadline =
                        selectedDeadline!.toUtc().toIso8601String();

                    // Используем parentContext для доступа к TodoBloc
                    parentContext.read<TodoBloc>().add(TodoCreateRequested(
                          title: title,
                          description: description,
                          assignedTo: selectedMemberId!,
                          deadline: DateTime.parse(formattedDeadline),
                        ));

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
