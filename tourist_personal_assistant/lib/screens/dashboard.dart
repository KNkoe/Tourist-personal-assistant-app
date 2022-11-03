import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tourist_personal_assistant/screens/widgets/details.dart';
import 'package:tourist_personal_assistant/screens/widgets/map.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/destination.dart';
import '../widgets/responsive.dart';
import 'destinations/caves.dart';
import 'destinations/dams.dart';
import 'destinations/mines.dart';
import 'destinations/mountains.dart';
import 'destinations/national_parks.dart';
import 'destinations/water_falls.dart';
import 'notifications.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

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

  bool isFocused = false;
  final TextEditingController searchController = TextEditingController();

  final List<Destination> _destinations = [];
  List<Destination> searchItems = [];
  List<String> searchStringList = [];

  populateList() {
    for (var destination in caves) {
      _destinations.add(destination);
    }
    for (var destination in dams) {
      _destinations.add(destination);
    }
    for (var destination in mountains) {
      _destinations.add(destination);
    }
    for (var destination in nationalParks) {
      _destinations.add(destination);
    }
    for (var destination in waterFalls) {
      _destinations.add(destination);
    }
    for (var destination in mines) {
      _destinations.add(destination);
    }

    for (int i = 0; i < _destinations.length; i++) {
      searchStringList.add(_destinations[i].title!.toLowerCase());
      debugPrint("${searchStringList[i]}\n");
    }
  }

  void filterSearchResults(String query) {
    populateList();

    if (query.isNotEmpty) {
      List<Destination> dummyListData = [];
      for (Destination destination in _destinations) {
        if (destination.title!.toLowerCase().contains(query.toLowerCase())) {
          if (!dummyListData.contains(destination)) {
            dummyListData.add(destination);
          }
        }
      }
      setState(() {
        searchItems.clear();
        searchItems.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _destinations.clear();
        searchItems.clear();
      });
    }
  }

  void requestPermission() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  void listenForNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        setState(() {
          notifications.add(message);
        });
        debugPrint("NOTIFICATION: ${notification.title}");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    listenForNotifications();
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
              onPressed: () {
                showModalBottomSheet(
                    barrierColor: Colors.black.withOpacity(0.3),
                    context: context,
                    builder: ((context) => StatefulBuilder(
                        builder: ((context, setState) => Container(
                              padding: const EdgeInsets.all(20),
                              child: notifications.isEmpty
                                  ? const Text("No new notifications")
                                  : ListView(
                                      children: notifications
                                          .map(
                                            (notification) => Column(
                                              children: [
                                                ListTile(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  tileColor: Theme.of(context)
                                                      .primaryColor,
                                                  title: Text(
                                                    notification
                                                        .notification!.title!,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: Text(
                                                    notification
                                                        .notification!.body!,
                                                    style: const TextStyle(
                                                        color: Colors.white60),
                                                  ),
                                                ),
                                                const Divider(
                                                  color: Colors.transparent,
                                                )
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                            )))));
              },
              icon: Badge(
                badgeContent: Text(
                  "${notifications.length}",
                  style: const TextStyle(color: Colors.white),
                ),
                showBadge: notifications.isNotEmpty,
                child: const Icon(
                  Icons.notifications,
                  color: Colors.black26,
                ),
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
              controller: searchController,
              cursorHeight: 20,
              onTap: () => setState(() {
                isFocused = true;
                populateList();
              }),
              onChanged: (value) => filterSearchResults(value),
              onSubmitted: (value) => setState(() {
                isFocused = false;
                searchController.clear();
              }),
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
            height: 10,
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
            height: 20,
          ),
          Expanded(
              child: isFocused
                  ? ListView(
                      children: searchItems
                          .map((destination) => ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DestinationDetails(
                                                  destination: destination)));
                                },
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.black26,
                                ),
                                title: Text(destination.title!),
                                subtitle: Text(destination.district!),
                              ))
                          .toList(),
                    )
                  : PageView(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: ((value) => setState(() {
                            selectedTabIndex = value;
                          })),
                      children: destinations
                          .map((e) => GridView.count(
                                childAspectRatio: 0.7,
                                controller:
                                    ScrollController(keepScrollOffset: false),
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                children: tabs(selectedTabIndex)
                                    .map((destination) => Animate(
                                          effects: const [
                                            FadeEffect(),
                                            SlideEffect(
                                                duration:
                                                    Duration(milliseconds: 200))
                                          ],
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            width:
                                                screenSize(context).width * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 10,
                                                      spreadRadius: 0,
                                                      offset:
                                                          const Offset(0, 1))
                                                ]),
                                            child: OpenContainer(
                                                closedElevation: 0,
                                                middleColor: Colors.white,
                                                closedColor: Colors.transparent,
                                                closedBuilder: (context,
                                                        action) =>
                                                    Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image(
                                                              height: 110,
                                                              width: 140,
                                                              fit: BoxFit.cover,
                                                              image: ResizeImage(
                                                                  AssetImage(
                                                                      destination
                                                                          .coverUrl!),
                                                                  height: 110,
                                                                  width: 140)),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                destination
                                                                    .title!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5,
                                                                  bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: Colors
                                                                          .black45),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    destination
                                                                        .district!,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black45),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ElevatedButton.icon(
                                                            onPressed: () {
                                                              _checkConnection()
                                                                  .then(
                                                                      (connect) {
                                                                if (connect) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                          MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MyMap(
                                                                      destination:
                                                                          destination,
                                                                    ),
                                                                  ));
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text("Please check that you are connected to the internet")));
                                                                }
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .directions),
                                                            label: const Text(
                                                                'Directions'))
                                                      ],
                                                    ),
                                                openBuilder:
                                                    (context, action) =>
                                                        DestinationDetails(
                                                            destination:
                                                                destination)),
                                          ),
                                        ))
                                    .toList(),
                              ))
                          .toList(),
                    ))
        ],
      ),
    );
  }
}
