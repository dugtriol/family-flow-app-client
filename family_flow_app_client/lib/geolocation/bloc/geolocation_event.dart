part of 'geolocation_bloc.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object> get props => [];
}

class MapInitialized extends GeolocationEvent {
  final YandexMapController mapController;

  const MapInitialized(this.mapController);

  @override
  List<Object> get props => [mapController];
}

class AddMarker extends GeolocationEvent {
  final Point location;

  const AddMarker(this.location);

  @override
  List<Object> get props => [location];
}

class MoveCamera extends GeolocationEvent {
  final Point location;
  final double zoom;

  const MoveCamera(this.location, this.zoom);

  @override
  List<Object> get props => [location, zoom];
}

class ZoomIn extends GeolocationEvent {}

class ZoomOut extends GeolocationEvent {}

class MarkerTapped extends GeolocationEvent {
  final Point location;

  const MarkerTapped(this.location);

  @override
  List<Object> get props => [location];
}

class RefreshMap extends GeolocationEvent {}
