import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_api/todo_api.dart' show TodoItem;
import 'todo_task_list.dart';

class TodoCalendarPage extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  final Map<DateTime, List<TodoItem>> tasksByDate;

  const TodoCalendarPage({
    super.key,
    required this.events,
    required this.tasksByDate,
  });

  @override
  State<TodoCalendarPage> createState() => _TodoCalendarPageState();
}

class _TodoCalendarPageState extends State<TodoCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'ru_RU',
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

            // Лог для отладки
            final normalizedDay = DateTime(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
            );
            final events = widget.events[normalizedDay] ?? [];
            debugPrint('Selected day: $normalizedDay, Events: $events');
          },
          eventLoader: (day) {
            final normalizedDay = DateTime(day.year, day.month, day.day);
            return widget.events[normalizedDay] ?? [];
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
        ),
        Expanded(child: _buildTasksForSelectedDay()),
      ],
    );
  }

  Widget _buildTasksForSelectedDay() {
    final normalizedDay =
        _selectedDay != null
            ? DateTime(
              _selectedDay!.year,
              _selectedDay!.month,
              _selectedDay!.day,
            )
            : null;

    final tasks =
        normalizedDay != null
            ? (widget.tasksByDate[normalizedDay] ?? <TodoItem>[])
            : <TodoItem>[];

    return TodoTaskList(tasks: tasks);
  }
}
