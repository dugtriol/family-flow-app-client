import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../authentication/authentication.dart';
import '../bloc/todo_bloc.dart';
import 'widgets/todo_list_views.dart';
import 'widgets/create_todo_button.dart';

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

class _TodoViewState extends State<TodoView> {
  String _selectedView = 'Назначенные мне'; // Выбранный список
  bool _isCalendarVisible = false; // Флаг для отображения календаря
  DateTime _focusedDay = DateTime.now(); // Текущая дата
  DateTime? _selectedDay; // Выбранная дата

  @override
  void initState() {
    super.initState();
    if (_selectedView == 'Назначенные мне') {
      context.read<TodoBloc>().add(TodoAssignedToRequested());
    } else if (_selectedView == 'Созданные мной') {
      context.read<TodoBloc>().add(TodoCreatedByRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.select(
      (AuthenticationBloc bloc) => bloc.state.user.id,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.deepPurple,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Задачи',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.deepPurple),
            onPressed: () {
              // Логика для уведомлений
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Устанавливаем цвет фона как у AppBar
      body: RefreshIndicator(
        onRefresh: () async {
          // Обновляем данные в зависимости от выбранного списка
          if (_selectedView == 'Назначенные мне') {
            context.read<TodoBloc>().add(TodoAssignedToRequested());
          } else if (_selectedView == 'Созданные мной') {
            context.read<TodoBloc>().add(TodoCreatedByRequested());
          }
        },
        child: Column(
          children: [
            // Кнопки календаря, фильтра и переключатель списков
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _selectedView,
                    items: const [
                      DropdownMenuItem(
                        value: 'Назначенные мне',
                        child: Text('Назначенные мне'),
                      ),
                      DropdownMenuItem(
                        value: 'Созданные мной',
                        child: Text('Созданные мной'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedView = value!;
                      });

                      // Вызываем соответствующее событие в зависимости от выбранного значения
                      if (_selectedView == 'Назначенные мне') {
                        context.read<TodoBloc>().add(TodoAssignedToRequested());
                      } else if (_selectedView == 'Созданные мной') {
                        context.read<TodoBloc>().add(TodoCreatedByRequested());
                      }
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isCalendarVisible = !_isCalendarVisible;
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        tooltip: 'Календарь', // Подсказка при наведении
                      ),
                      IconButton(
                        onPressed: () {
                          // Логика для фильтрации задач
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.deepPurple,
                        ),
                        tooltip: 'Фильтр', // Подсказка при наведении
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Календарь
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ), // Длительность анимации
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0, // Анимация сверху вниз
                  child: child,
                );
              },
              child:
                  _isCalendarVisible
                      ? _buildCalendar() // Календарь отображается плавно
                      : const SizedBox.shrink(), // Пустое место, если календарь скрыт
            ),
            // Список задач
            Expanded(
              child:
                  _selectedView == 'Назначенные мне'
                      ? const AssignedToListView()
                      : const CreatedByListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: CreateTodoButton(currentUserId: currentUserId),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ru_RU', // Устанавливаем русский язык
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
