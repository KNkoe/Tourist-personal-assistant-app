import 'package:flutter/material.dart';
import 'package:tourist_personal_assistant/screens/explore.dart';
import 'package:tourist_personal_assistant/screens/favourites.dart';
import 'package:tourist_personal_assistant/screens/settings.dart';

import 'dashboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedNavBarIndex = 0;

  Widget screen(int index) {
    switch (index) {
      case 0:
        return const Dashboard();
      case 1:
        return const Explore();
      case 2:
        return const Favourites();
      case 3:
        return const Settings();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen(selectedNavBarIndex),
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
