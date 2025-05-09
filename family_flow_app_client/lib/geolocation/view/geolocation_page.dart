// ignore_for_file: use_build_context_synchronously

import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user_api/user_api.dart' show User;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../bloc/geolocation_bloc.dart';

class GeolocationPage extends StatefulWidget {
  const GeolocationPage({super.key});

  @override
  State<GeolocationPage> createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  String? _selectedFamilyMember; // Выбранный член семьи

  @override
  void initState() {
    super.initState();
    // Инициализация списка членов семьи (заглушка, заменить на реальные данные)
    final familyState = context.read<FamilyBloc>().state;
    if (familyState is FamilyLoadSuccess && familyState.members.isNotEmpty) {
      _selectedFamilyMember = familyState.members.first.name;
    }
  }

  void _onFamilyMemberChanged(String? newValue) {
    setState(() {
      _selectedFamilyMember = newValue;
    });

    // Получаем данные выбранного члена семьи из FamilyBloc
    final familyState = context.read<FamilyBloc>().state;
    if (familyState is FamilyLoadSuccess) {
      print("Выбранный член семьи: $newValue");
      print("Список членов семьи: ${familyState.members}");
      final selectedMember = familyState.members.firstWhere(
        (member) => member.name == newValue,
        orElse: () {
          print("Член семьи с именем $newValue не найден.");
          return User.empty; // Возвращаем пустого пользователя, если не найден
        },
      );

      if (selectedMember == null) {
        return; // Прекращаем выполнение, если член семьи не найден
      }

      print(
        "Выбранный член семьи: ${selectedMember.name} (${selectedMember.latitude}, ${selectedMember.longitude})",
      );

      // Проверяем, есть ли координаты у выбранного члена семьи
      if (selectedMember.latitude != null && selectedMember.longitude != null) {
        // Отправляем событие для перемещения карты к выбранному члену семьи
        final bloc = context.read<GeolocationBloc>();
        print(
          "Перемещение к члену семьи: ${selectedMember.name} (${selectedMember.latitude}, ${selectedMember.longitude})",
        );
        bloc.add(
          MoveToLocation(
            latitude: selectedMember.latitude!,
            longitude: selectedMember.longitude!,
          ),
        );
      } else {
        print(
          "Координаты для ${selectedMember.name} отсутствуют. Перемещение невозможно.",
        );
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включена ли служба геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Проверяем разрешения
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Получаем текущую позицию
    return await Geolocator.getCurrentPosition();
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
            icon: const Icon(Icons.update_rounded, color: Colors.deepPurple),
            onPressed: () async {
              try {
                final position = await _determinePosition();
                print(
                  'Текущая позиция: ${position.latitude}, ${position.longitude}',
                );
                context.read<AuthenticationBloc>().add(
                  AuthenticationLocationUpdateRequested(
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
                );
                context.read<FamilyBloc>().add(FamilyRequested());
              } catch (e) {
                print('Ошибка при получении геолокации: $e');
              }
            },
            tooltip: 'Обновить геолокацию',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Карта
          BlocBuilder<GeolocationBloc, GeolocationState>(
            builder: (context, geoState) {
              final bloc = context.read<GeolocationBloc>();
              return YandexMap(
                onMapCreated: (controller) {
                  bloc.add(MapInitialized(controller));

                  final familyState = context.read<FamilyBloc>().state;

                  if (familyState is FamilyLoadSuccess) {
                    for (final member in familyState.members) {
                      if (member.latitude != null && member.longitude != null) {
                        print(
                          "Добавление маркера: ${member.name} (${member.latitude}, ${member.longitude})",
                        );
                        bloc.add(
                          AddMarker(
                            Point(
                              latitude: member.latitude!,
                              longitude: member.longitude!,
                            ),
                            member.name,
                          ),
                        );
                      } else {
                        print(
                          "Координаты для ${member.name} отсутствуют. Маркер не добавлен.",
                        );
                      }
                    }
                  }
                },
                mapObjects: geoState is MapReady ? geoState.mapObjects : [],
              );
            },
          ),

          // Список выбора членов семьи
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: BlocBuilder<FamilyBloc, FamilyState>(
              builder: (context, familyState) {
                if (familyState is FamilyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (familyState is FamilyLoadSuccess) {
                  // context.read<FamilyBloc>().add(FamilyRequested());
                  final familyMembers = familyState.members;

                  // Устанавливаем начальное значение, если оно ещё не задано
                  if (_selectedFamilyMember == null &&
                      familyMembers.isNotEmpty) {
                    _selectedFamilyMember = familyMembers.first.name;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFamilyMember,
                      isExpanded: true,
                      items:
                          familyMembers.map((member) {
                            return DropdownMenuItem<String>(
                              value: member.name,
                              child: Text(
                                member.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: _onFamilyMemberChanged,
                      underline: Container(),
                    ),
                  );
                } else if (familyState is FamilyLoadFailure) {
                  print('Ошибка загрузки семьи: ${familyState.error}');
                  return Center(
                    child: Text(
                      'Ошибка: ${familyState.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Кнопки управления масштабом
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       title: Row(
  //         children: [
  //           const Icon(Icons.location_on, color: Colors.deepPurple, size: 28),
  //           const SizedBox(width: 8),
  //           const Text(
  //             'Геолокация',
  //             style: TextStyle(
  //               color: Colors.black87,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.refresh, color: Colors.deepPurple),
  //           onPressed: () {
  //             final bloc = context.read<GeolocationBloc>();
  //             bloc.add(RefreshMap()); // Обновляем карту
  //           },
  //           tooltip: 'Обновить карту',
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: Stack(
  //             children: [
  //               BlocBuilder<GeolocationBloc, GeolocationState>(
  //                 builder: (context, state) {
  //                   final bloc = context.read<GeolocationBloc>();
  //                   return YandexMap(
  //                     onMapCreated: (controller) {
  //                       bloc.add(MapInitialized(controller));

  //                       // Добавляем маркеры для всех членов семьи
  //                       for (final member in _familyMembers) {
  //                         bloc.add(
  //                           AddMarker(
  //                             Point(
  //                               latitude: member['latitude'],
  //                               longitude: member['longitude'],
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     mapObjects: state is MapReady ? state.mapObjects : [],
  //                   );
  //                 },
  //               ),
  //               Positioned(
  //                 top: 16,
  //                 left: 16,
  //                 right: 16,
  //                 child: DropdownButton<String>(
  //                   value: _selectedFamilyMember,
  //                   isExpanded: true,
  //                   items:
  //                       _familyMembers.map((member) {
  //                         return DropdownMenuItem<String>(
  //                           value: member['name'],
  //                           child: Text(
  //                             member['name'],
  //                             style: const TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w500,
  //                               color: Colors.black87,
  //                             ),
  //                           ),
  //                         );
  //                       }).toList(),
  //                   onChanged: _onFamilyMemberChanged,
  //                   underline: Container(height: 2, color: Colors.deepPurple),
  //                 ),
  //               ),
  //               Positioned(
  //                 right: 16,
  //                 bottom: 100,
  //                 child: Column(
  //                   children: [
  //                     FloatingActionButton(
  //                       heroTag: 'zoom_in',
  //                       onPressed: () {
  //                         final bloc = context.read<GeolocationBloc>();
  //                         bloc.add(ZoomIn()); // Увеличиваем масштаб
  //                       },
  //                       child: const Icon(Icons.add),
  //                       mini: true,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     FloatingActionButton(
  //                       heroTag: 'zoom_out',
  //                       onPressed: () {
  //                         final bloc = context.read<GeolocationBloc>();
  //                         bloc.add(ZoomOut()); // Уменьшаем масштаб
  //                       },
  //                       child: const Icon(Icons.remove),
  //                       mini: true,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }