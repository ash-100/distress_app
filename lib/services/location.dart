import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

final Permission _permission = Permission.location;
bool _checkingPermission = false;

Future<void> _checkPermission(Permission permission) async {
  final status = await permission.request();
  if (status == PermissionStatus.granted) {
    print('Permission granted');
  } else if (status == PermissionStatus.denied) {
    print('Permission denied. Show a dialog and again ask for the permission');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
  }
}

Future enableLocation(BuildContext context) async {
  bool serviceEnabled;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    enableLocationAlert(context);
    return Future.error('Location services are disabled.');
  } else {
    _getGeoLocationPermission(context);
  }
}

Future _getGeoLocationPermission(BuildContext context) async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      locationAlert(context);
    }
  }
  if (permission == LocationPermission.deniedForever) {
    locationAlert(context);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}

void locationAlert(BuildContext context) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Location'),
          content:
              Text('You must enable location access in order to use this app'),
          actions: [
            TextButton(
                onPressed: () async {
                  LocationPermission locationPermission =
                      await Geolocator.checkPermission();
                  if (locationPermission == LocationPermission.whileInUse ||
                      locationPermission == LocationPermission.always) {
                    Navigator.of(context).pop(true);
                  } else {
                    await Geolocator.requestPermission();
                  }
                },
                child: Text('Enable')),
            TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  //Navigator.of(context).pop(true);
                },
                child: Text('Exit'))
          ],
        );
      });
}

void enableLocationAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Location Service'),
          content:
              Text('You must enable location access in order to use this app'),
          actions: [
            TextButton(
                onPressed: () async {
                  //await Geolocator.openLocationSettings();
                  await Geolocator.openLocationSettings();
                  bool service = await Geolocator.isLocationServiceEnabled();
                  if (service) {
                    Navigator.of(context).pop(true);
                    _getGeoLocationPermission(context);
                  }
                },
                child: Text('Enable')),
            TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  //Navigator.of(context).pop(true);
                },
                child: Text('Exit'))
          ],
        );
      });
}
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   super.didChangeAppLifecycleState(state);
//   if (state == AppLifecycleState.resumed && !_checkingPermission) {
//     _checkingPermission = true;
//     _checkPermission(_permission).then((_) => _checkingPermission = false);
//   }
// }
