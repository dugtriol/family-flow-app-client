part of 'geolocation_bloc.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();

  @override
  List<Object> get props => [];
}

class GeolocationInitial extends GeolocationState {}

class MapReady extends GeolocationState {
  final List<MapObject> mapObjects;

  const MapReady(this.mapObjects);

  @override
  List<Object> get props => [mapObjects];
}
