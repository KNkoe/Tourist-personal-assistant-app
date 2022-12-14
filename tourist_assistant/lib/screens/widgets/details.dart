import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../models/destination.dart';
import '../../widgets/responsive.dart';
import 'map.dart';

class DestinationDetails extends StatefulWidget {
  const DestinationDetails({super.key, required this.destination});

  final Destination destination;

  @override
  State<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails> {
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
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  expandedHeight: screenSize(context).height * 0.45,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1.6,
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(20),
                    title: Text(
                      widget.destination.title!.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.8),
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.white12],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height + 200));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(widget.destination.imgUrl!)),
                    ),
                  ),
                )
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.destination.district!,
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.destination.description!,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  )
                ],
              ),
            ),
          )),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FloatingActionButton.extended(
          onPressed: () {
            _checkConnection().then((connect) {
              if (connect) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyMap(
                    destination: widget.destination,
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Please check that you are connected to the internet")));
              }
            });
          },
          icon: const Icon(Icons.directions),
          label: const Text("Directions"),
        )
      ],
    );
  }
}
