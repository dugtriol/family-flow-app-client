import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart' show TodoItem;
import '../../authentication/authentication.dart';
import '../../notifications/notifications.dart';
import '../bloc/todo_bloc.dart';
import 'widgets/todo_list_views.dart';
import 'widgets/create_todo_button.dart';
import 'widgets/todo_calendar_page.dart';
import 'package:notification_api/models/notification.dart' as NotificationApi;

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
  Map<DateTime, List<String>> _events = {}; // События на календаре
  Map<DateTime, List<TodoItem>> _tasksByDate = {};
  bool _hasNewNotifications = false; // Флаг для новых уведомлений
  // List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    if (_selectedView == 'Назначенные мне') {
      context.read<TodoBloc>().add(TodoAssignedToRequested());
    } else if (_selectedView == 'Созданные мной') {
      context.read<TodoBloc>().add(TodoCreatedByRequested());
    }
    _requestNotificationPermission();
    _configureFCM();
    context.read<NotificationsBloc>().add(LoadNotifications());
  }

  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Уведомления разрешены');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Уведомления запрещены');
    }
  }

  Future<void> _configureFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Получение токена устройства
    String? token = await messaging.getToken();
    print('FCM Token: $token');

    if (token != null) {
      // Отправляем токен через NotificationsBloc
      context.read<NotificationsBloc>().add(SaveFcmToken(token));
    }

    // Обработка входящих уведомлений
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Получено уведомление: ${message.notification?.title}');
      final notification = NotificationApi.Notification(
        id: message.messageId ?? '',
        userId: message.data['user_id'] ?? '',
        title: message.notification?.title ?? 'Без заголовка',
        body: message.notification?.body ?? 'Нет описания',
        data: message.data.toString(),
        isRead: false,
        createdAt: DateTime.now(),
      );

      // Добавляем уведомление в Bloc
      context.read<NotificationsBloc>().add(AddNotification(notification));

      // Устанавливаем флаг для новых уведомлений
      setState(() {
        _hasNewNotifications = true;
      });
    });
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
          // IconButton(
          //   icon: const Icon(Icons.notifications, color: Colors.deepPurple),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder:
          //             (context) =>
          //                 BlocBuilder<NotificationsBloc, NotificationsState>(
          //                   builder: (context, state) {
          //                     if (state is NotificationsLoading) {
          //                       return const Center(
          //                         child: CircularProgressIndicator(),
          //                       );
          //                     } else if (state is NotificationsLoadSuccess) {
          //                       return NotificationsPage(
          //                         notifications: state.notifications,
          //                       );
          //                     } else if (state is NotificationsLoadFailure) {
          //                       return const Center(
          //                         child: Text(
          //                           'Ошибка при загрузке уведомлений',
          //                           style: TextStyle(color: Colors.red),
          //                         ),
          //                       );
          //                     }
          //                     return const Center(
          //                       child: Text('Нет уведомлений'),
          //                     );
          //                   },
          //                 ),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications, color: Colors.deepPurple),
                if (_hasNewNotifications)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(80),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 6,
                        minHeight: 6,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (
                        context,
                      ) => BlocListener<NotificationsBloc, NotificationsState>(
                        listener: (context, state) {
                          if (state is NotificationsLoadSuccess) {
                            // Сбрасываем флаг новых уведомлений
                            setState(() {
                              _hasNewNotifications = false;
                            });
                          }
                        },
                        child:
                            BlocBuilder<NotificationsBloc, NotificationsState>(
                              builder: (context, state) {
                                if (state is NotificationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is NotificationsLoadSuccess) {
                                  return NotificationsPage(
                                    notifications: state.notifications,
                                  );
                                } else if (state is NotificationsLoadFailure) {
                                  return const Center(
                                    child: Text(
                                      'Ошибка при загрузке уведомлений',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: Text('Нет уведомлений'),
                                );
                              },
                            ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          if (_selectedView == 'Назначенные мне') {
            context.read<TodoBloc>().add(TodoAssignedToRequested());
          } else if (_selectedView == 'Созданные мной') {
            context.read<TodoBloc>().add(TodoCreatedByRequested());
          }
        },
        child: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoAssignedToLoadSuccess) {
              _updateEvents(state.todos); // Используем state.todos
            } else if (state is TodoCreatedByLoadSuccess) {
              _updateEvents(state.todos); // Используем state.todos
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

                        if (_selectedView == 'Назначенные мне') {
                          context.read<TodoBloc>().add(
                            TodoAssignedToRequested(),
                          );
                        } else if (_selectedView == 'Созданные мной') {
                          context.read<TodoBloc>().add(
                            TodoCreatedByRequested(),
                          );
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
                          tooltip: 'Календарь',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    _isCalendarVisible
                        ? TodoCalendarPage(
                          events: _events,
                          tasksByDate: _tasksByDate,
                          currentUserId: currentUserId,
                        )
                        : (_selectedView == 'Назначенные мне'
                            ? const AssignedToListView()
                            : const CreatedByListView()),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CreateTodoButton(currentUserId: currentUserId),
    );
  }

  void _updateEvents(List<TodoItem> todos) {
    print('Updating events with ${todos.length} todos');

    final Map<DateTime, List<String>> events = {};
    final Map<DateTime, List<TodoItem>> tasksByDate = {};

    for (final todo in todos) {
      final deadline = todo.deadline.toLocal();
      if (deadline != null) {
        final date = DateTime(deadline.year, deadline.month, deadline.day);

        // Обновляем _events
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(todo.title);

        // Обновляем _tasksByDate
        if (tasksByDate[date] == null) {
          tasksByDate[date] = [];
        }
        tasksByDate[date]!.add(todo);
      }
    }

    setState(() {
      _events = events;
      _tasksByDate = tasksByDate;
    });

    for (final entry in _events.entries) {
      debugPrint('Date: ${entry.key}, Events: ${entry.value}');
    }
  }
}
