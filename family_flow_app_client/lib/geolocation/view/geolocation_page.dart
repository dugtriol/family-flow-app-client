import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../bloc/geolocation_bloc.dart';

class GeolocationPage extends StatefulWidget {
  const GeolocationPage({super.key});

  @override
  State<GeolocationPage> createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  String? _selectedFamilyMember; // Выбранный член семьи
  List<Map<String, dynamic>> _familyMembers =
      []; // Список членов семьи с координатами

  @override
  void initState() {
    super.initState();
    // Инициализация списка членов семьи (заглушка, заменить на реальные данные)
    _familyMembers = [
      {'name': 'Иван', 'latitude': 55.751244, 'longitude': 37.618423}, // Москва
      {
        'name': 'Мария',
        'latitude': 59.934280,
        'longitude': 30.335099,
      }, // Санкт-Петербург
      {'name': 'Анна', 'latitude': 48.856613, 'longitude': 2.352222}, // Париж
    ];
    _selectedFamilyMember = _familyMembers.first['name'];
  }

  void _onFamilyMemberChanged(String? newValue) {
    setState(() {
      _selectedFamilyMember = newValue;
    });

    // Находим координаты выбранного члена семьи
    final selectedMember = _familyMembers.firstWhere(
      (member) => member['name'] == newValue,
    );

    // Отправляем событие для перемещения карты к выбранному члену семьи
    // final bloc = context.read<GeolocationBloc>();
    // bloc.add(
    //   MoveToLocation(
    //     latitude: selectedMember['latitude'],
    //     longitude: selectedMember['longitude'],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.deepPurple, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Геолокация',
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
            icon: const Icon(Icons.refresh, color: Colors.deepPurple),
            onPressed: () {
              final bloc = context.read<GeolocationBloc>();
              bloc.add(RefreshMap()); // Обновляем карту
            },
            tooltip: 'Обновить карту',
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<GeolocationBloc, GeolocationState>(
            builder: (context, state) {
              final bloc = context.read<GeolocationBloc>();
              return YandexMap(
                onMapCreated: (controller) {
                  bloc.add(MapInitialized(controller));

                  // Добавляем маркер на фиксированное место
                  bloc.add(
                    AddMarker(
                      const Point(latitude: 55.751244, longitude: 37.618423),
                    ),
                  ); // Москва
                },
                mapObjects: state is MapReady ? state.mapObjects : [],
              );
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: DropdownButton<String>(
              value: _selectedFamilyMember,
              isExpanded: true,
              items:
                  _familyMembers.map((member) {
                    return DropdownMenuItem<String>(
                      value: member['name'],
                      child: Text(
                        member['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: _onFamilyMemberChanged,
              underline: Container(height: 2, color: Colors.deepPurple),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    final bloc = context.read<GeolocationBloc>();
                    bloc.add(ZoomIn()); // Увеличиваем масштаб
                  },
                  child: const Icon(Icons.add),
                  mini: true,
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    final bloc = context.read<GeolocationBloc>();
                    bloc.add(ZoomOut()); // Уменьшаем масштаб
                  },
                  child: const Icon(Icons.remove),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
