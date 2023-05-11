import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:favoriteplace/data/models/two_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import '../../../data/models/place.dart';
import '../../../data/models/static_geo_point.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit() : super(PlaceInitial());

  void getAllPlaces() {
    try {
      emit(PlaceLoading());
      late List<StaticGeoPoint> staticGeoPoints;
      final Box placeBox = Hive.box("Favorite_Places");
      List<Place> placeList =
          List.castFrom(placeBox.get("placesList", defaultValue: []))
              .cast<Place>();
      staticGeoPoints = placeList
          .map((place) => StaticGeoPoint(
              id: place.id,
              location: StaticPositionGeoPoint(
                  DateTime.now().millisecondsSinceEpoch.toString() +
                      Random().nextInt(268228).toString(),
                  const MarkerIcon(
                      icon: Icon(
                    Icons.location_on_outlined,
                    size: 120,
                    color: Colors.red,
                  )),
                  [
                    GeoPoint(
                        latitude: place.latitude, longitude: place.longitude)
                  ])))
          .toList();
      emit(PlaceLoaded(twolist: TwoLists(placeList, [])));
      emit(PlaceLoaded(twolist: TwoLists(placeList, staticGeoPoints)));
    } catch (e) {
      emit(PlaceLoadFailure(error: "Error: $e"));
    }
  }

  void addPlace(Place place, List<Place> placeList) {
    try {
      emit(PlaceAdding());
      final Box placeBox = Hive.box("Favorite_Places");
      placeList.add(place);
      placeBox.put("placesList", placeList);
      placeBox.add(place);
      emit(PlaceAdded());
      getAllPlaces();
    } catch (e) {
      emit(PlaceAddFailure(error: "Error: $e"));
    }
  }

  void deletePlace(int index, List<Place> placeList) {
    try {
      emit(PlaceDeleting());
      final Box placeBox = Hive.box("Favorite_Places");
      placeList.removeAt(index);
      placeBox.put("placesList", placeList);
      placeBox.delete(index);
      emit(PlaceDeleted());
      getAllPlaces();
    } catch (e) {
      emit(PlaceDeletingFailure(error: "Error: $e"));
    }
  }
}
