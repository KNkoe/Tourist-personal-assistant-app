import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tourist_personal_assistant/models/destination.dart';
import 'package:tourist_personal_assistant/screens/destinations/caves.dart';
import 'package:tourist_personal_assistant/screens/destinations/dams.dart';
import 'package:tourist_personal_assistant/screens/destinations/mines.dart';
import 'package:tourist_personal_assistant/screens/destinations/mountains.dart';
import 'package:tourist_personal_assistant/screens/destinations/national_parks.dart';
import 'package:tourist_personal_assistant/screens/destinations/water_falls.dart';
import 'package:tourist_personal_assistant/screens/widgets/details.dart';
import 'package:tourist_personal_assistant/widgets/responsive.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: explore
            .map(
              (destination) => Animate(
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
                      child: Padding(
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
                    ),
                    openBuilder: (context, action) =>
                        DestinationDetails(destination: destination),
                  )),
            )
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration:
                BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.directions),
            ),
          ),
          SizedBox(
            height: screenSize(context).height * 0.05,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration:
                BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.favorite),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
