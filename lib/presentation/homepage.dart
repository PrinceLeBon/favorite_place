import 'package:favoriteplace/presentation/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../business_logic/cubits/place/place_cubit.dart';
import '../data/models/place.dart';
import 'add_place.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Place> placeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text("Favorite Places"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Maps();
                  }));
                },
                icon: const Icon(Icons.map))
          ],
        ),
        body:
            BlocBuilder<PlaceCubit, PlaceState>(builder: (context, placeState) {
          if (placeState is PlaceLoaded) {
            if (placeState.twolist.list1.isNotEmpty) {
              placeList = placeState.twolist.list1;
              return ListView.builder(
                  itemCount: placeState.twolist.list1.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: IconButton(
                              onPressed: () {
                                context.read<PlaceCubit>().deletePlace(
                                    index, placeState.twolist.list1);
                              },
                              icon: const Icon(Icons.delete)),
                          title: Text(placeState.twolist.list1[index].name),
                          subtitle:
                              Text(placeState.twolist.list1[index].comment),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("You haven't favorite places"));
            }
          } else if (placeState is PlaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (placeState is PlaceLoadFailure) {
            return const Center(
                child: Text("Please try later, we have an error"));
          } else {
            return Center(
                child: TextButton(
                    onPressed: () {
                      context.read<PlaceCubit>().getAllPlaces();
                    },
                    child: const Text(
                      "Tap to reload",
                      style: TextStyle(fontSize: 16),
                    )));
          }
        }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddFavoritePlace(
                  placeList: placeList,
                );
              }));
            },
            child: const Icon(Icons.add)));
  }
}
