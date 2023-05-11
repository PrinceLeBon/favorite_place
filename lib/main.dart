import 'package:favoriteplace/business_logic/cubits/place/place_cubit.dart';
import 'package:favoriteplace/business_logic/cubits/static_geo_points/static_geo_points_cubit.dart';
import 'package:favoriteplace/presentation/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'data/models/place.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());
  await Hive.openBox("Favorite_Places");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => PlaceCubit()..getAllPlaces()),
          BlocProvider(
              create: (BuildContext context) => StaticGeoPointsCubit()),
        ],
        child: MaterialApp(
          title: 'Favorite Places',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
