import 'package:favoriteplace/business_logic/cubits/place/place_cubit.dart';
import 'package:favoriteplace/data/models/place.dart';
import 'package:favoriteplace/presentation/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class AddFavoritePlace extends StatefulWidget {
  final List<Place> placeList;

  const AddFavoritePlace({Key? key, required this.placeList}) : super(key: key);

  @override
  State<AddFavoritePlace> createState() => _AddFavoritePlaceState();
}

class _AddFavoritePlaceState extends State<AddFavoritePlace> {
  late MapController mapController = MapController.withUserPosition(
    areaLimit: const BoundingBox.world(),
  );

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceCubit, PlaceState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Choose Place as favorite"),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2,
                              child: OSMFlutter(
                                controller: mapController,
                                trackMyPosition: true,
                                initZoom: 19,
                                stepZoom: 1,
                                roadConfiguration: const RoadOption(
                                  roadColor: Colors.yellowAccent,
                                ),
                                markerOption: MarkerOption(
                                    defaultMarker: const MarkerIcon(
                                  icon: Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.blue,
                                    size: 100,
                                  ),
                                )),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    await mapController
                                        .advancedPositionPicker();
                                  },
                                  child: const Icon(Icons.my_location),
                                ))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black),
                                controller: myController1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter favorite place name";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.location_on_outlined),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    hintText: "Enter favorite place name"),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black),
                                controller: myController2,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.comment),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    hintText: "Enter note or comment"),
                              )
                            ],
                          ),
                        )
                      ],
                    ))),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final PlaceCubit placeCubit = context.read<PlaceCubit>();
                    GeoPoint p = await mapController
                        .getCurrentPositionAdvancedPositionPicker();

                    placeCubit.addPlace(
                        Place(
                            id: widget.placeList.length,
                            name: myController1.text.trim(),
                            comment: myController2.text.trim().isEmpty
                                ? " "
                                : myController2.text.trim(),
                            latitude: p.latitude,
                            longitude: p.longitude),
                        widget.placeList);
                  }
                },
                child: (state is PlaceAdding)
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.check)),
          );
        },
        listener: (context, state) {
          if (state is PlaceAdded){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }), (route) => false);
           /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));*/
          }
        });
  }
}
