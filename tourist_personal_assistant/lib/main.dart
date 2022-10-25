import 'package:flutter/material.dart';
import 'package:tourist_personal_assistant/widgets/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Personal Assistant',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
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
                    selectedIndex = 0;
                  });
                },
                color: selectedIndex == 0
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.home_filled)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                color: selectedIndex == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.explore)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                color: selectedIndex == 2
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.favorite)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                },
                color: selectedIndex == 3
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}
