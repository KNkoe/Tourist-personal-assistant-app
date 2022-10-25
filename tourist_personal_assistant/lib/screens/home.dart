import 'package:flutter/material.dart';
import 'package:tourist_personal_assistant/widgets/responsive.dart';
import 'package:animations/animations.dart';

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
                          setState(() {
                            selectedTabIndex =
                                destinations.indexOf(destination);
                          });
                          if (destinations.indexOf(destination) > 2) {
                            _scrollController.animateTo(200,
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease);
                          }
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
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  closedColor: Colors.transparent,
                  closedBuilder: (context, action) => Column(
                    children: [
                      Container(
                        height: 110,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/images/Caves/Kome caves/cover.jpg"))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Kome Caves",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "4.3",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.black45),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Berea",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.black45,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'))
                    ],
                  ),
                  openBuilder: (context, action) => Container(),
                ),
              )
            ],
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
