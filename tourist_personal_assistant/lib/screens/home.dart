import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:tourist_personal_assistant/screens/destinations/national_parks.dart';
import 'package:tourist_personal_assistant/screens/destinations/water_falls.dart';

import '../models/destination.dart';
import '../widgets/responsive.dart';
import 'destinations/caves.dart';
import 'destinations/dams.dart';
import 'destinations/mines.dart';
import 'destinations/mountains.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  int selectedNavBarIndex = 0;
  int selectedTabIndex = 0;

  List<String> destinations = [
    "Caves",
    "Dams",
    "Mountains",
    "National parks",
    "Water falls",
    "Mines"
  ];

  List<Destination> tabs(int index) {
    switch (index) {
      case 0:
        return caves;
      case 1:
        return dams;
      case 2:
        return mountains;
      case 3:
        return nationalParks;
      case 4:
        return waterFalls;
      case 5:
        return mines;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Personal Assistant'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.black26,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              cursorHeight: 20,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: const Center(child: Text('Search destination')),
                  contentPadding: EdgeInsets.only(
                      bottom: 10, right: screenSize(context).width * 0.1)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: screenSize(context).width,
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              children: destinations
                  .map((destination) => GestureDetector(
                        onTap: () {
                          if (destinations.indexOf(destination) > 2 &&
                              selectedTabIndex <
                                  destinations.indexOf(destination)) {
                            _scrollController.animateTo(200,
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease);
                          }

                          setState(() {
                            selectedTabIndex =
                                destinations.indexOf(destination);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedTabIndex ==
                                    destinations.indexOf(destination)
                                ? Theme.of(context).primaryColor
                                : Colors.black12,
                          ),
                          child: Text(
                            destination,
                            style: TextStyle(
                                color: selectedTabIndex ==
                                        destinations.indexOf(destination)
                                    ? Colors.white70
                                    : Colors.black38),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
              child: GridView.count(
            childAspectRatio: 0.7,
            controller: ScrollController(keepScrollOffset: false),
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            children: tabs(selectedTabIndex)
                .map((destination) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      width: screenSize(context).width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: 0,
                                offset: const Offset(0, 1))
                          ]),
                      child: OpenContainer(
                          closedElevation: 0,
                          middleColor: Colors.white,
                          closedColor: Colors.transparent,
                          closedBuilder: (context, action) => Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        height: 110,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        image: ResizeImage(
                                            AssetImage(destination.coverUrl!),
                                            height: 110,
                                            width: 140)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          destination.title!,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.black45),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              destination.district!,
                                              style: const TextStyle(
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.favorite_outline,
                                            size: 18,
                                            color: Colors.black45,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.directions),
                                      label: const Text('Directions'))
                                ],
                              ),
                          openBuilder: (context, action) => Scaffold(
                                body: NestedScrollView(
                                    headerSliverBuilder: ((context,
                                            innerBoxIsScrolled) =>
                                        [
                                          SliverAppBar(
                                            elevation: 0,
                                            leading: GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                            ),
                                            expandedHeight:
                                                screenSize(context).height *
                                                    0.5,
                                            floating: false,
                                            pinned: true,
                                            flexibleSpace: FlexibleSpaceBar(
                                              expandedTitleScale: 1.6,
                                              centerTitle: true,
                                              title: Text(
                                                destination.title!
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    letterSpacing: 1.8),
                                              ),
                                              background: ShaderMask(
                                                shaderCallback: (rect) {
                                                  return const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black,
                                                      Colors.white12
                                                    ],
                                                  ).createShader(Rect.fromLTRB(
                                                      0,
                                                      0,
                                                      rect.width,
                                                      rect.height + 200));
                                                },
                                                blendMode: BlendMode.dstIn,
                                                child: Image(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        destination.imgUrl!)),
                                              ),
                                            ),
                                          )
                                        ]),
                                    body: Text(destination.description!)),
                                bottomNavigationBar: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(100, 50)),
                                      icon: const Icon(Icons.directions),
                                      label: const Text("Directions")),
                                ),
                              )),
                    ))
                .toList(),
          ))
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBarIndex = 0;
                  });
                },
                color: selectedNavBarIndex == 0
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.home_filled)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBarIndex = 1;
                  });
                },
                color: selectedNavBarIndex == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.explore)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBarIndex = 2;
                  });
                },
                color: selectedNavBarIndex == 2
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.favorite)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBarIndex = 3;
                  });
                },
                color: selectedNavBarIndex == 3
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}
