import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class StaticGeoPoint {
  final int id;
  final StaticPositionGeoPoint location;

  StaticGeoPoint({required this.id, required this.location});
}
