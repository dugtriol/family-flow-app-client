import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:yandex_maps_mapkit_lite/init.dart' as init;

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru', null);
  Bloc.observer = AppBlocObserver();

  // final authenticationRepository = AuthenticationRepository();
  // await authenticationRepository.user.first;
  // init.initMapkit(apiKey: 'a6f9dfc0-7ab3-44c1-a592-fc6086fd98cd');

  runApp(App());
}
