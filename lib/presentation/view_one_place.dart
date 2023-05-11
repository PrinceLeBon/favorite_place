import 'package:favoriteplace/presentation/widgets/place_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:logger/logger.dart';
import '../business_logic/cubits/static_geo_points/static_geo_points_cubit.dart';
import '../data/models/place.dart';

class ViewOneFavoritePlace extends StatefulWidget {
  final Place place;

  const ViewOneFavoritePlace({Key? key, required this.place}) : super(key: key);

  @override
  State<ViewOneFavoritePlace> createState() => _ViewOneFavoritePlaceState();
}

class _ViewOneFavoritePlaceState extends State<ViewOneFavoritePlace> {
  final MapController mapController = MapController.withUserPosition(
    areaLimit: const BoundingBox.world(),
  );

  late final PageController _pageController;

  late GeoPoint myLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.blue,
                size: 30,
              )),
        ),
        body: BlocBuilder<StaticGeoPointsCubit, StaticGeoPointsState>(
            builder: (context, state) {
          if (state is StaticGeoPointsLoaded) {
            Logger().i(state.liste.length);
            Logger().i(widget.place.longitude);
            Logger().i(widget.place.longitude);
            return Stack(
              children: [
                OSMFlutter(
                  controller: mapController,
                  trackMyPosition: true,
                  initZoom: 19,
                  stepZoom: 1,
                  staticPoints: state.liste,
                  markerOption: MarkerOption(
                      defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.yellow,
                      size: 100,
                    ),
                  )),
                ),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<double?>>(
                          future: route(GeoPoint(
                              latitude: widget.place.latitude,
                              longitude: widget.place.longitude)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue),
                              );
                            } else if (snapshot.hasData) {
                              List<double?> detailFromRoad = snapshot.data!;
                              return PlaceCard(detailFromRoad: detailFromRoad);
                            } else if (snapshot.hasError) {
                              return Center(
                                child: TextButton(
                                    onPressed: () async {
                                      await route(GeoPoint(
                                          latitude: widget.place.latitude,
                                          longitude: widget.place.longitude));
                                    },
                                    child: const Text("Tap to reload")),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.red),
                              );
                            }
                          },
                        )))
              ],
            );
          } else if (state is StaticGeoPointsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
                child: Text("Pas de Static Position Geo Points disponible"));
          }
        }));
  }

  Future<List<double?>> route(GeoPoint location) async {
    await Future.delayed(const Duration(seconds: 1));
    myLocation = await mapController.myLocation();
    RoadInfo roadInfo = await mapController.drawRoad(
      myLocation,
      location,
      roadType: RoadType.bike,
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );
    return [
      roadInfo.distance,
      roadInfo.duration,
    ];
  }
}
