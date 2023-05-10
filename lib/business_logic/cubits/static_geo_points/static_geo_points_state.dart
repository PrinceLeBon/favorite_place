part of 'static_geo_points_cubit.dart';

@immutable
abstract class StaticGeoPointsState {}

class StaticGeoPointsInitial extends StaticGeoPointsState {}

class StaticGeoPointsLoading extends StaticGeoPointsState {}

class StaticGeoPointsLoaded extends StaticGeoPointsState {
  final List<StaticPositionGeoPoint> liste;

  StaticGeoPointsLoaded({required this.liste});
}

class StaticGeoPointsFailed extends StaticGeoPointsState {
  final String error;

  StaticGeoPointsFailed({required this.error});
}
