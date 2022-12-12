import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sunset_app/constants/constants.dart';
import 'package:sunset_app/core/extensions/color_extension.dart';
import 'package:sunset_app/core/extensions/context_entension.dart';
import 'package:sunset_app/utils/locale_keys.dart';
import 'dart:io' as io;
import 'package:location/location.dart';



class AppService {

  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await io.InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on io.SocketException catch (_) {
      internet = false;
    }
    return internet;
  }
}

errorAlert(BuildContext context, errorMessage) {
  Widget closeButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: context.containerBorderRadiusLow,
            side: BorderSide(width: 1, color: context.colors.orangeColor)),
        minimumSize: Size(context.width * 0.8, context.height * 0.06)),
    child: const Text(
      LocaleKeys.okey,
      style: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop(context);
    },
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          backgroundColor: context.colors.backgroundSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: context.containerBorderRadiusLow,
              side: BorderSide(width: 1, color: context.colors.grayTwoColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: context.height*0.1,
                  child: Image.asset('assets/cross.png', fit: BoxFit.fitHeight,)),
              context.emptyMediumHighWidget,
              Text(
                errorMessage ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  color: context.colors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          titlePadding: const EdgeInsets.all(0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: context.width*0.5,
                    child: closeButton),
              ],
            )
          ],
        );
      });
}

infoDialog(BuildContext context, double lat, double long, String sunRise, String sunSet) {

  Widget closeButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: context.containerBorderRadiusLow,
            side: BorderSide(width: 1, color: context.colors.orangeColor)),
        minimumSize: Size(context.width * 0.8, context.height * 0.06)),
    child: const Text(
      LocaleKeys.okey,
      style: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop(context);
    },
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          backgroundColor: context.colors.backgroundSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: context.containerBorderRadiusLow,
              side: BorderSide(width: 1, color: context.colors.grayTwoColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: context.height*0.1,
                  child: Image.asset('assets/cross.png', fit: BoxFit.fitHeight,)),
              context.emptyMediumHighWidget,
             // Text(LocaleKeys.location + "lat: " + lat.toString() + "long: " +  long.toString()),
              Row(
                children: const [
                  Text(LocaleKeys.hint),
                ],
              ),
              Text(LocaleKeys.sunrise + sunRise),
              Text(LocaleKeys.sunset + sunSet)
            ],
          ),
          titlePadding: const EdgeInsets.all(0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: context.width*0.5,
                    child: closeButton),
              ],
            )
          ],
        );
      });
}

Future<void> addUser(String id, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance.collection("users").doc(id).set(data);
}

Future getLocation() async {

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  return _locationData;
}

Future getSunTimes(double lat, double long) async {
  var result = await Dio().post(Constants.baseUrl + "lat=" + lat.toString() + "&lng=" + long.toString());
  return result.data["results"];
}

