import 'dart:math';

import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/destination.dart';
import '../widgets/responsive.dart';
import 'destinations/caves.dart';
import 'destinations/dams.dart';
import 'destinations/mines.dart';
import 'destinations/mountains.dart';
import 'destinations/national_parks.dart';
import 'destinations/water_falls.dart';
import 'widgets/details.dart';
import 'widgets/map.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Destination> explore = [];

  Random random = Random();
  int randomNumber = 0;

  @override
  void initState() {
    super.initState();

    for (var element in caves) {
      explore.add(element);
    }

    for (var element in dams) {
      explore.add(element);
    }

    for (var element in mountains) {
      explore.add(element);
    }

    for (var element in nationalParks) {
      explore.add(element);
    }

    for (var element in waterFalls) {
      explore.add(element);
    }

    for (var element in mines) {
      explore.add(element);
    }

    explore.shuffle();
  }

  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: explore.map((destination) {
          return Animate(
              effects: const [
                FadeEffect(duration: Duration(milliseconds: 700)),
                SlideEffect(duration: Duration(milliseconds: 600))
              ],
              child: OpenContainer(
                closedBuilder: (context, action) => Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(bottom: 20),
                  height: screenSize(context).height,
                  width: screenSize(context).width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(destination.imgUrl!))),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white38, shape: BoxShape.circle),
                          child: FloatingActionButton(
                            onPressed: () {
                              _checkConnection().then((connect) {
                                if (connect) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyMap(
                                      destination: destination,
                                    ),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please check that you are connected to the internet")));
                                }
                              });
                            },
                            child: const Icon(Icons.directions),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(
                                fit: BoxFit.cover,
                                height: 100,
                                width: screenSize(context).width,
                                image: const AssetImage(
                                    "assets/images/car_road.gif")),
                            Text(
                              destination.title!.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  letterSpacing: 1.8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                openBuilder: (context, action) =>
                    DestinationDetails(destination: destination),
              ));
        }).toList(),
      ),
    );
  }
}
