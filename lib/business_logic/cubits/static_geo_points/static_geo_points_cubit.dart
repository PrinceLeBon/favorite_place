import 'package:bloc/bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:meta/meta.dart';
import '../../../data/models/static_geo_point.dart';

part 'static_geo_points_state.dart';

class StaticGeoPointsCubit extends Cubit<StaticGeoPointsState> {
  StaticGeoPointsCubit() : super(StaticGeoPointsInitial());

  void getStaticsGeoPoint(List<StaticGeoPoint> staticGeoPoints, int id) {
    try {
      emit(StaticGeoPointsLoading());
      List<StaticPositionGeoPoint> listFrom = staticGeoPoints
          .where((sgp) => sgp.id == id)
          .expand((staticGeoPoint) => [staticGeoPoint.location])
          .toList();
      emit(StaticGeoPointsLoaded(liste: listFrom));
    } catch (e) {
      emit(StaticGeoPointsFailed(error: "Error: $e"));
    }
  }
}
