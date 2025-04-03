import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  Bloc.observer = AppBlocObserver();

  // final authenticationRepository = AuthenticationRepository();
  // await authenticationRepository.user.first;

  runApp(App());
}
