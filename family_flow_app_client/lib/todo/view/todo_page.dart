import 'package:family_flow_app_client/todo/view/widgets/todo_list_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Для форматирования даты
import 'package:todo_repository/todo_repository.dart';
import '../bloc/todo_bloc.dart';
import 'widgets/todo_detail_dialog.dart';
import 'widgets/widgets.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoView();
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Слушаем изменения вкладок
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<TodoBloc>().add(TodoAssignedToRequested());
      } else if (_tabController.index == 1) {
        context.read<TodoBloc>().add(TodoCreatedByRequested());
      }
    });

    // Загружаем данные для первой вкладки
    context.read<TodoBloc>().add(TodoAssignedToRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TodoBloc>(), // Передаем текущий TodoBloc
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Assigned To'),
              Tab(text: 'Created By'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AssignedToListView(),
            CreatedByListView(),
          ],
        ),
        floatingActionButton: const CreateTodoButton(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// class _TodoListView extends StatelessWidget {
//   const _TodoListView({required this.onRefresh, super.key});

//   final VoidCallback onRefresh;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TodoBloc, TodoState>(
//       builder: (context, state) {
//         if (state is TodoLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is TodoLoadSuccess) {
//           if (state.todos.isEmpty) {
//             return const Center(child: Text('No todos found.'));
//           }
//           return ListView.builder(
//             itemCount: state.todos.length,
//             itemBuilder: (context, index) {
//               final todo = state.todos[index];
//               final tileColor = _getTileColor(todo.status);
//               final formattedDate = _formatDate(todo.deadline);

//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: tileColor,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Icon(
//                     todo.status.toLowerCase() == 'completed'
//                         ? Icons.check_circle
//                         : Icons.radio_button_unchecked,
//                     color: todo.status.toLowerCase() == 'completed'
//                         ? Colors.green
//                         : Colors.blue,
//                     size: 32,
//                   ),
//                   title: Text(
//                     todo.title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         todo.description,
//                         style: const TextStyle(
//                             fontSize: 14, color: Colors.black87),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Статус: ${todo.status}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                   trailing: Text(
//                     formattedDate,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   onTap: () {
//                     // Открываем диалог с подробной информацией о задаче
//                     showDialog(
//                       context: context,
//                       builder: (context) => TodoDetailsDialog(
//                         todo: todo,
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         } else if (state is TodoLoadFailure) {
//           return const Center(child: Text('Failed to load todos.'));
//         }
//         return const Center(child: Text('Press refresh to load todos.'));
//       },
//     );
//   }

//   Color _getTileColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green.withOpacity(0.1); // Светло-зеленый для Completed
//       case 'active':
//         return Colors.blue.withOpacity(0.1); // Светло-синий для Active
//       default:
//         return Colors.grey.withOpacity(0.1); // Серый для неизвестного статуса
//     }
//   }

//   String _formatDate(DateTime date) {
//     final formatter = DateFormat('d MMM', 'ru');
//     return formatter.format(date);
//   }
// }
