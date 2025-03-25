import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  // final authenticationRepository = AuthenticationRepository();
  // await authenticationRepository.user.first;

  runApp(App());
}
