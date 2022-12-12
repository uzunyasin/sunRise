import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sunset_app/core/extensions/color_extension.dart';
import 'package:sunset_app/core/extensions/context_entension.dart';
import 'package:sunset_app/services/app_services.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

late double lat;
late double long;
late LocationData locData;
late String sunRise;
late String sunSet;

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundPrimary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.colors.orangeColor,
        child: Image.asset('assets/location.png'),
        onPressed: () {
          getLocation().then((value) {
            setState(() {
              locData = value;
              print(locData.toString());
              lat = locData.latitude!;
              long = locData.longitude!;
              print("lat " + lat.toString());
              print("long " + long.toString());
            });
            getSunTimes(lat, long).then((value) {
              print("giden lat " + lat.toString());
              print("giden long " + long.toString());
              sunRise = value["sunrise"];
              sunSet = value["sunset"];
              infoDialog(context,lat,lat,sunRise,sunSet);
            });
          });
        },
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
    );
  }
}
