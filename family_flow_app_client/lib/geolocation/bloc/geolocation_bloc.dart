import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as dart_ui;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  late YandexMapController _mapController;
  final List<MapObject> _mapObjects = [];

  GeolocationBloc() : super(GeolocationInitial()) {
    on<MapInitialized>((event, emit) {
      _mapController = event.mapController;
      emit(MapReady([]));
    });

    on<AddMarker>((event, emit) async {
      print(
        'Добавление маркера: ${event.location.latitude}, ${event.location.longitude}, ${event.name}',
      );
      final currentState = state;
      if (currentState is MapReady) {
        // Создаём кастомное изображение с текстом
        final imageWithText = await _createCustomMarkerWithText(
          'lib/assets/user.png',
          event.name,
        );

        // Создаём новый маркер
        final marker = PlacemarkMapObject(
          mapId: MapObjectId(
            'marker_${event.location.latitude}_${event.location.longitude}',
          ),
          point: event.location,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromBytes(imageWithText),
              scale: 1.5,
            ),
          ),
          onTap: (PlacemarkMapObject self, Point point) {
            print(
              'Маркер нажат: ${point.latitude}, ${point.longitude} ${event.name}',
            );
            add(MarkerTapped(point)); // Обрабатываем нажатие на маркер
          },
        );

        // Обновляем список объектов карты
        _mapObjects.add(marker);

        print(
          'Добавлено маркер: ${event.location.latitude}, ${event.location.longitude}, ${event.name}',
        );

        print('Текущее количество объектов на карте: ${_mapObjects.length}');

        emit(MapReady(_mapObjects));
      }
    });

    on<MoveToLocation>((event, emit) async {
      if (_mapController != null) {
        print(
          "Перемещение карты к координатам: ${event.latitude}, ${event.longitude}",
        );
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: event.latitude,
                longitude: event.longitude,
              ),
              zoom: 14.0,
            ),
          ),
        );
      } else {
        print("Контроллер карты не инициализирован. Перемещение невозможно.");
      }
    });

    on<ZoomIn>((event, emit) async {
      if (_mapController != null) {
        await _mapController.moveCamera(
          CameraUpdate.zoomIn(),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1.0,
          ),
        );
      }
    });

    on<ZoomOut>((event, emit) async {
      if (_mapController != null) {
        await _mapController.moveCamera(
          CameraUpdate.zoomOut(),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1.0,
          ),
        );
      }
    });

    on<RefreshMap>((event, emit) {
      print('Обновление карты');
      _mapObjects.clear(); // Очищаем текущие маркеры
      emit(MapReady(List.from(_mapObjects))); // Обновляем состояние карты
    });

    on<MarkerTapped>((event, emit) {
      print('Маркер нажат: ${event.location} ');
      // Здесь можно добавить дополнительную логику при нажатии на маркер
    });
  }

  Future<Uint8List> _createCustomMarkerWithText(
    String imagePath,
    String text,
  ) async {
    final pictureRecorder = dart_ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();

    // Загружаем изображение
    final image = await _loadImageFromAssets(imagePath);
    canvas.drawImage(image, Offset.zero, paint);

    // Добавляем текст
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, image.height.toDouble()));

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(
      image.width,
      (image.height + textPainter.height).toInt(),
    );
    final byteData = await img.toByteData(format: dart_ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<dart_ui.Image> _loadImageFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final codec = await dart_ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
