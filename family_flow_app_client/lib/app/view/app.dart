import 'package:authentication_repository/authentication_repository.dart';
import 'package:chats_repository/chats_repository.dart';
import 'package:diary_repository/diary_repository.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../authentication/authentication.dart';
import '../../chats/chats.dart';
import '../../diary/diary.dart';
import '../../family/family.dart';
import '../../home/view/view.dart';
import '../../login/view/view.dart';
import '../../notifications/notifications.dart';
import '../../splash/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthenticationRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => TodoRepository()),
        RepositoryProvider(
          create:
              (context) => FamilyRepository(
                userRepository: context.read<UserRepository>(),
              ),
        ),
        RepositoryProvider(create: (_) => ShoppingRepository()),
        RepositoryProvider(create: (_) => WishlistRepository()),
        RepositoryProvider(create: (_) => NotificationRepository()),
        RepositoryProvider(create: (_) => ChatsRepository()),
        RepositoryProvider(create: (_) => DiaryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create:
                (context) => AuthenticationBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                  userRepository: context.read<UserRepository>(),
                  todoRepository: context.read<TodoRepository>(),
                  shoppingRepository: context.read<ShoppingRepository>(),
                )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create:
                (context) => FamilyBloc(
                  familyRepository: context.read<FamilyRepository>(),
                  authenticationBloc: context.read<AuthenticationBloc>(),
                )..add(FamilyRequested()),
          ),
          BlocProvider(
            create:
                (context) => NotificationsBloc(
                  notificationRepository:
                      context.read<NotificationRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) =>
                    ChatsBloc(chatsRepository: context.read<ChatsRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    DiaryBloc(diaryRepository: context.read<DiaryRepository>()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Логируем нажатие на уведомление
        debugPrint('Notification clicked: ${response.payload}');
      },
    );
  }

  Future<void> _showTestNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'Family Flow', // ID канала
          'Вход пользователя', // Имя канала
          channelDescription: 'Добро пожаловать в Family Flow!',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.show(
      0, // ID уведомления
      'Family Flow', // Заголовок
      'Добро пожаловать в Family Flow!', // Текст
      notificationDetails,
      payload: 'Test Payload', // Полезная нагрузка
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                // Показываем тестовое уведомление при успешной аутентификации
                // _showTestNotification();
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
