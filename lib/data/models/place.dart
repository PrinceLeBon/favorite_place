import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 1)
class Place {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String comment;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;

  const Place(
      {required this.id,
      required this.name,
      required this.comment,
      required this.latitude,
      required this.longitude});
}
