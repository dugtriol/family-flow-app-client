import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  late YandexMapController _mapController;
  final List<MapObject> _mapObjects = [];

  GeolocationBloc() : super(GeolocationInitial());

  @override
  Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
    if (event is MapInitialized) {
      _mapController = event.mapController;
      yield MapReady(_mapObjects);
    } else if (event is AddMarker) {
      print(
          'Добавление маркера: ${event.location.latitude}, ${event.location.longitude}');

      final marker = PlacemarkMapObject(
        mapId: MapObjectId(
            'marker_${event.location.latitude}_${event.location.longitude}'),
        point: event.location,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/user.png'),
            scale: 1.5,
          ),
        ),
        onTap: (PlacemarkMapObject self, Point point) {
          print('Маркер нажат: ${point.latitude}, ${point.longitude}');
          add(MarkerTapped(point)); // Обрабатываем нажатие на маркер
        },
      );

      _mapObjects.add(marker);
      print('Текущее количество объектов на карте: ${_mapObjects.length}');
      yield MapReady(List.from(_mapObjects));
    } else if (event is ZoomIn) {
      _mapController.moveCamera(
        CameraUpdate.zoomIn(),
        animation:
            const MapAnimation(type: MapAnimationType.smooth, duration: 1.0),
      );
    } else if (event is ZoomOut) {
      _mapController.moveCamera(
        CameraUpdate.zoomOut(),
        animation:
            const MapAnimation(type: MapAnimationType.smooth, duration: 1.0),
      );
    } else if (event is MarkerTapped) {
      print('Маркер нажат: ${event.location}');
      // Здесь можно добавить дополнительную логику при нажатии на маркер
    } else if (event is RefreshMap) {
      print('Обновление карты');
      _mapObjects.clear(); // Очищаем текущие маркеры
      yield MapReady(List.from(_mapObjects)); // Обновляем состояние карты
    }
  }
}
