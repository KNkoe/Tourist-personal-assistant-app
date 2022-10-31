import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> favourites = SharedPreferences.getInstance();

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
