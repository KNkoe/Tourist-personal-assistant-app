import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    Permission.location.isGranted
        .then((value) => setState(() => permissionsGranted = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
              ),
              const Text("Location permissions"),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Switch(
                    value: permissionsGranted,
                    onChanged: ((value) async {
                      if (await Permission.location.request().isGranted) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Location permisssios are granted")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Please change permissions in your phone settings")));
                      }
                    })),
              )
            ],
          ),
          const Divider()
        ]),
      ),
    );
  }
}
