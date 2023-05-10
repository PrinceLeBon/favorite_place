import 'package:favoriteplace/presentation/widgets/place_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        appBar: AppBar(),
        body: Stack(
          children: [
            OSMFlutter(
              controller: mapController,
              trackMyPosition: false,
              initZoom: 19,
              stepZoom: 1,
              staticPoints: [],
              markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 100,
                ),
              )),
            ),
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 1,
                    onPageChanged: (onPageChangedIndex) async {
                      setState(() {
                        _currentIndex = onPageChangedIndex;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder<List<double?>>(
                        future: route(
                            GeoPoint(
                                latitude: double.parse(""),
                                longitude: double.parse("")),
                            GeoPoint(
                                latitude: double.parse(""),
                                longitude: double.parse("")),
                            Colors.blue,
                            Colors.red),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.blue),
                            );
                          } else if (snapshot.hasData) {
                            List<double?> detailFromRoad = snapshot.data!;
                            return Column(
                              children: [
                                PlaceCard(detailFromRoad: detailFromRoad),
                                SmoothPageIndicator(
                                  controller: _pageController,
                                  // PageController
                                  count: 1,
                                )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                  "Balayer vers la droite ou la gauche pour défiler"),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    },
                  ),
                ))
          ],
        ));
  }

  Future<List<double?>> route(GeoPoint store, GeoPoint destination,
      Color colorStore, Color colorDestination) async {
    myLocation = await mapController.myLocation();
    RoadInfo roadInfo = await mapController.drawRoad(
      myLocation,
      store,
      roadType: RoadType.bike,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: colorStore,
        zoomInto: true,
      ),
    );
    RoadInfo roadInfo1 = await mapController.drawRoad(
      store,
      destination,
      roadType: RoadType.bike,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: colorDestination,
        zoomInto: true,
      ),
    );

    return [
      roadInfo.distance,
      roadInfo.duration,
      roadInfo1.distance,
      roadInfo1.duration,
      roadInfo1.duration! + roadInfo.duration!,
    ];
  }
}
