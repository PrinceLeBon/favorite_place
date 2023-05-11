import 'package:flutter/material.dart';
import 'package:favoriteplace/presentation/widgets/place_card.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../business_logic/cubits/place/place_cubit.dart';
import '../business_logic/cubits/static_geo_points/static_geo_points_cubit.dart';
import '../data/models/place.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final MapController mapController = MapController.withUserPosition(
    areaLimit: const BoundingBox.world(),
  );

  late final PageController _pageController;
  int _currentIndex = 0;

  late GeoPoint myLocation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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
        body:
            BlocBuilder<PlaceCubit, PlaceState>(builder: (context, placeState) {
          if (placeState is PlaceLoaded) {
            if (placeState.twolist.list1.isNotEmpty) {
              context.read<StaticGeoPointsCubit>().getStaticsGeoPoint(
                  placeState.twolist.list2,
                  placeState.twolist.list1[_currentIndex].id);
              return BlocBuilder<StaticGeoPointsCubit, StaticGeoPointsState>(
                  builder: (context, staticPointState) {
                if (staticPointState is StaticGeoPointsLoaded) {
                  return Stack(
                    children: [
                      OSMFlutter(
                        controller: mapController,
                        trackMyPosition: false,
                        initZoom: 19,
                        stepZoom: 1,
                        staticPoints: staticPointState.liste,
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
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: placeState.twolist.list1.length,
                              onPageChanged: (onPageChangedIndex) async {
                                setState(() {
                                  _currentIndex = onPageChangedIndex;
                                });
                                context
                                    .read<StaticGeoPointsCubit>()
                                    .getStaticsGeoPoint(
                                        placeState.twolist.list2,
                                        placeState
                                            .twolist.list1[_currentIndex].id);
                                await mapController.clearAllRoads();
                              },
                              itemBuilder: (BuildContext context, int index) {
                                Place place =
                                    placeState.twolist.list1[_currentIndex];
                                return FutureBuilder<List<double?>>(
                                  future: route(GeoPoint(
                                      latitude: place.latitude,
                                      longitude: place.longitude)),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.blue),
                                      );
                                    } else if (snapshot.hasData) {
                                      List<double?> detailFromRoad =
                                          snapshot.data!;
                                      return Column(
                                        children: [
                                          PlaceCard(
                                              detailFromRoad: detailFromRoad),
                                          SmoothPageIndicator(
                                            controller: _pageController,
                                            // PageController
                                            count:
                                                placeState.twolist.list1.length,
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: TextButton(
                                            onPressed: () {
                                              context
                                                  .read<PlaceCubit>()
                                                  .getAllPlaces();
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
                                );
                              },
                            ),
                          ))
                    ],
                  );
                } else if (staticPointState is StaticGeoPointsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                      child:
                          Text("Pas de Static Position Geo Points disponible"));
                }
              });
            } else {
              return const Center(child: Text("You haven't favorite places"));
            }
          } else if (placeState is PlaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
                child: Text("Please try later, we have an error"));
          }
        }));
  }

  Future<List<double?>> route(GeoPoint location) async {
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
