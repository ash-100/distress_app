import 'package:distress_app/screens/profile.dart';
import 'package:distress_app/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:distress_app/help.dart';
import 'package:distress_app/services/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:distress_app/globals.dart' as globals;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  Future<void> saveTokenToDatabase(String? token) async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? device_Id = await globals.getDeviceId();
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    dynamic response = await http.post(
      Uri.parse('${globals.domain}/api/savetoken'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'email': email,
        'token': token,
        'role': 'user',
        'device_id': device_Id
      }),
    );
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
  }

  static const platform = const MethodChannel('sendSms');
  Future saveState(RequiredHelp notifier) async {
    var jsonMap = jsonDecode(notifier.userInfo);
    jsonMap['help_required'] = true;

    await notifier.setHelpstate(jsonEncode(jsonMap), notifier.contactsIndex);
  }

  Future<Null> sendSms(String phone) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitude, longitude;
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    try {
      final String result =
          await platform.invokeMethod('send', <String, dynamic>{
        "phone": "+91" + phone,
        "msg":
            "Raksha App IITI: Help me!! I am at this location.https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"
      }); //Replace a 'X' with 10 digit phone number
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    enableLocation(context);
    return Consumer<RequiredHelp>(builder: (context, RequiredHelp notifier, _) {
      return Scaffold(
        key: _key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: AppBar(
            centerTitle: true,
            leading: Column(
              children: [
                SizedBox(height: 30),
                GestureDetector(
                    onTap: () => _key.currentState!.openDrawer(),
                    child: Icon(Icons.menu))
              ],
            ),
            actions: [
              Column(
                children: [
                  SizedBox(height: 30),
                  GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: FaIcon(
                          FontAwesomeIcons.circleInfo,
                        ),
                      )),
                ],
              )
            ],
            title: Column(
              children: [
                SizedBox(height: 30),
                Text('RAKSHA IITI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'PlayFair Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 23)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () async {
                      var jsonMap = jsonDecode(notifier.userInfo);
                      if (!jsonMap['help_required']) {
//bool? permissionsGranted = await telephony
                        //  .requestPhoneAndSmsPermissions;
                        await [Permission.sms, Permission.location].request();
                        for (var i = 0; i < jsonMap['contacts'].length; i++) {
                          sendSms(jsonMap['contacts'][i]['mobile_no']);
                        }

                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          jsonMap['help_required'] = true;

                          await notifier.init(
                              jsonEncode(jsonMap), notifier.contactsIndex);
                          // Functionality to be added
                          try {
                            await globals.sendRequest();
                            setState(() {
                              loading = false;
                            });

                            await globals.successalertbox(
                                "Request sent", context);
                            //Navigator.of(context).pop();
                          } catch (e) {
                            //await saveState(notifier);
                            await globals.erroralertbox(
                                "Error,check your internet connection",
                                context);
                          }
                        }
                      } else {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await globals.cancelRequest();
                            setState(() {
                              loading = false;
                            });
                            var jsonMap = jsonDecode(notifier.userInfo);
                            jsonMap['help_required'] = false;
                            await notifier.setHelpstate(jsonEncode(jsonMap), 0);
                            globals.erroralertbox("Request cancelled", context);
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            globals.erroralertbox(
                                "Error,check your internet connection",
                                context);
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      //margin:
                      //EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                          // borderRadius:
                          //   BorderRadius.circular(50),
                          color: Color.fromRGBO(188, 51, 51, 1),
                          shape: BoxShape.circle),
                      child: Center(
                        child: !loading
                            ? !jsonDecode(notifier.userInfo)['help_required']
                                ? Container(
                                    height: 188,
                                    width: 188,
                                    //margin:
                                    //EdgeInsets.symmetric(horizontal: 60),
                                    decoration: BoxDecoration(
                                        // borderRadius:
                                        //   BorderRadius.circular(50),
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.solidBell,
                                        color: Color.fromRGBO(188, 51, 51, 1),
                                        size: 70,
                                      ),
                                    ))
                                : Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      color: Colors.white,
                                      size: 70,
                                    ),
                                  ) /*Text(
                                                "Send Request",
                                                style: GoogleFonts.notoSans(
                                                    color: Colors.white),
                                              )*/
                            : CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                jsonDecode(notifier.userInfo)['help_required']
                    ? 'Cancel'
                    : 'Send SOS',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              SizedBox(height: 20),
              jsonDecode(notifier.userInfo)['help_required']
                  ? GestureDetector(
                      onTap: () {
                        var jsonMap = jsonDecode(notifier.userInfo);

                        FlutterPhoneDirectCaller.callNumber('+91' +
                            jsonMap['contacts'][notifier.contactsIndex]
                                ['mobile_no']);
                        if (notifier.contactsIndex <
                            jsonMap['contacts'].length - 1) {
                          notifier.setHelpstate(
                              notifier.userInfo, notifier.contactsIndex + 1);
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[800],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.phoneVolume,
                                  size: 20, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Emergency Call",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(188, 51, 51, 1),
                ),
                child: Center(
                  child: Text(
                    user.displayName!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  // Must be redirected to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              ListTile(
                title: Text('About App'),
                onTap: () {
                  // Must be redirected to about app page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () async {
                  // Must be redirected to profile page
                  // Navigator.pop(context);
                  await AuthService().logOut();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
