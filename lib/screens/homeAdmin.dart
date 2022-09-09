// ignore_for_file: file_names
import 'package:distress_app/screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:distress_app/screens/userDetails.dart';
import 'package:distress_app/services/auth.dart';
import 'package:distress_app/services/database.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:distress_app/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:distress_app/help.dart';
import 'package:distress_app/services/location.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>.broadcast();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  IO.Socket socket = IO.io('ws://103.159.214.169:80/ws/help/',
      OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  //When an event recieved from server, data is added to the stream
  socket.on('event', (data) => streamSocket.addResponse);
  socket.onDisconnect((_) => print('disconnect'));
}

//Step3: Build widgets with streambuilder

class homeAdmin extends StatefulWidget {
  @override
  State<homeAdmin> createState() => _homeAdminState();
}

// final channel = IOWebSocketChannel.connect('ws://103.159.214.169:80/ws/help/')
//     .stream
//     .asBroadcastStream();

class _homeAdminState extends State<homeAdmin> with WidgetsBindingObserver {
  int selectedIndex = 0;
  bool loading_help = false;
  bool loading = false;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = <Widget>[];

  Future<void> saveTokenToDatabase(String? token) async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? device_Id = await globals.getDeviceId();
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    try {
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
          'role': 'admin',
          'device_id': device_Id
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
  }

  @override
  void initState() {
    super.initState();
    getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const platform = const MethodChannel('sendSms');

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

  Future<List> getActiveRequests() async {
    String? idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    var url = Uri.parse('${globals.domain}/api/requests/active');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    });
    var data = json.decode(response.body);
    return data;
  }

  Future saveState(RequiredHelp notifier) async {
    var jsonMap = jsonDecode(notifier.userInfo);
    jsonMap['help_required'] = true;

    await notifier.setHelpstate(jsonEncode(jsonMap), notifier.contactsIndex);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    enableLocation(context);
    final User user = Provider.of<User>(context);

    //enableLocation(context);

    return Consumer<RequiredHelp>(builder: (context, RequiredHelp notifier, _) {
      //notifier.loadRequiredHelp();
      return SafeArea(
        child: Scaffold(
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
          bottomNavigationBar: Visibility(
            visible: !jsonDecode(notifier.userInfo)['help_required'],
            child: BottomNavigationBar(
              selectedItemColor: Color.fromRGBO(188, 51, 51, 1),
              unselectedItemColor: Color.fromRGBO(188, 51, 51, .5),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: 'Help Requests')
              ],
              currentIndex: selectedIndex,
              onTap: onItemTapped,
            ),
          ),
          body: Center(
              child: selectedIndex == 0
                  ? Padding(
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
                                    await [Permission.sms, Permission.location]
                                        .request();
                                    for (var i = 0;
                                        i < jsonMap['contacts'].length;
                                        i++) {
                                      sendSms(
                                          jsonMap['contacts'][i]['mobile_no']);
                                    }

                                    if (!loading) {
                                      setState(() {
                                        loading = true;
                                      });
                                      jsonMap['help_required'] = true;

                                      await notifier.init(jsonEncode(jsonMap),
                                          notifier.contactsIndex);
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
                                        // await saveState(notifier);
                                        setState(() {
                                          loading = false;
                                        });
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
                                        var jsonMap =
                                            jsonDecode(notifier.userInfo);
                                        jsonMap['help_required'] = false;
                                        await notifier.setHelpstate(
                                            jsonEncode(jsonMap), 0);
                                        globals.erroralertbox(
                                            "Request cancelled", context);
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
                                        ? !jsonDecode(notifier.userInfo)[
                                                'help_required']
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
                                                    color: Color.fromRGBO(
                                                        188, 51, 51, 1),
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
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )*/
                                        : CircularProgressIndicator(
                                            color: Colors.white),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 17),
                          ),
                          SizedBox(height: 20),
                          jsonDecode(notifier.userInfo)['help_required']
                              ? GestureDetector(
                                  onTap: () {
                                    var jsonMap = jsonDecode(notifier.userInfo);

                                    FlutterPhoneDirectCaller.callNumber('+91' +
                                        jsonMap['contacts']
                                                [notifier.contactsIndex]
                                            ['mobile_no']);
                                    if (notifier.contactsIndex <
                                        jsonMap['contacts'].length - 1) {
                                      notifier.setHelpstate(notifier.userInfo,
                                          notifier.contactsIndex + 1);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green[800],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.phoneVolume,
                                              size: 20, color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            "Emergency Call",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    )
                  : loading
                      ? globals.Loading()
                      : StreamBuilder(
                          stream: streamSocket.getResponse,
                          builder: (context, snapshot) {
                            return FutureBuilder<List>(
                                future: getActiveRequests(),
                                builder: (context, snapshot) {
                                  // print(FirebaseAuth.instance.currentUser);
                                  if (!snapshot.hasData) {
                                    return Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: SpinKitChasingDots(
                                          color: Color.fromRGBO(188, 51, 51, 1),
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text('No Requests',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    );
                                  } else {
                                    List<dynamic>? data = snapshot.data;
                                    // loading = false;
                                    return loading_help
                                        ? globals.Loading()
                                        : ListView(
                                            children: data!.map((doc) {
                                              var issue = "";
                                              var name = doc['name'];
                                              var email = doc['email'];
                                              var help_sent_at = "";
                                              var status = doc['help_status'];
                                              DateTime help_time;
                                              String h = "";
                                              DateTime sent_time =
                                                  DateTime.parse(
                                                      doc['request_sent_at']);
                                              String t = DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(sent_time);
                                              if (doc['issue'] != null) {
                                                issue = doc['issue'];
                                              }
                                              if (doc['help_sent_at'] != null) {
                                                help_sent_at =
                                                    doc['help_sent_at'];
                                                help_time = DateTime.parse(
                                                    doc['request_sent_at']);
                                                h = DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(help_time);
                                              }
                                              return Container(
                                                padding: EdgeInsets.all(6),
                                                child: InkWell(
                                                  child: AbsorbPointer(
                                                    absorbing: loading,
                                                    child: Card(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: status ==
                                                                              "Pending"
                                                                          ? Colors
                                                                              .yellow
                                                                          : Colors
                                                                              .green,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                              5)),
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          5),
                                                                  child: Text(
                                                                      status,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: status ==
                                                                                "Pending"
                                                                            ? Colors.black
                                                                            : Colors.white,
                                                                      )))),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Name : $name",
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Email : $email',
                                                            ),
                                                          ),
                                                          help_sent_at
                                                                  .isNotEmpty
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'Help sent at :' +
                                                                        h,
                                                                  ),
                                                                )
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'Req Sent at :' +
                                                                        t,
                                                                  ),
                                                                ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              help_sent_at
                                                                      .isEmpty
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        try {
                                                                          setState(
                                                                              () {
                                                                            loading_help =
                                                                                true;
                                                                          });
                                                                          await DatabaseService(email: email)
                                                                              .helpsent();
                                                                          setState(
                                                                              () {
                                                                            loading_help =
                                                                                false;
                                                                          });
                                                                          globals.successalertbox(
                                                                              'Help Sent',
                                                                              context);
                                                                        } catch (e) {
                                                                          setState(
                                                                              () {
                                                                            loading_help =
                                                                                false;
                                                                          });
                                                                          globals.erroralertbox(
                                                                              'Error occured, try again',
                                                                              context);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 20),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(40),
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        child: Center(
                                                                            child: Text(
                                                                          "Help Sent",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                      ),
                                                                    )
                                                                  : SizedBox
                                                                      .shrink(),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          true,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Raksha IITI'),
                                                                          content:
                                                                              Text('Are you sure you want to delete this request?'),
                                                                          actions: [
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {
                                                                                    loading_help = true;
                                                                                  });
                                                                                  try {
                                                                                    await DatabaseService(email: email).removeRequest();
                                                                                    setState(() {
                                                                                      loading_help = false;
                                                                                    });

                                                                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request deleted')));
                                                                                  } catch (e) {
                                                                                    setState(() {
                                                                                      loading_help = false;
                                                                                    });
                                                                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error, check your internet connection and try again')));
                                                                                    // globals.erroralertbox('Error, check your internet connection and try again',
                                                                                    //     context);
                                                                                  }
                                                                                },
                                                                                child: Text('Delete')),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                                                                  Navigator.of(context).pop(true);
                                                                                },
                                                                                child: Text('Cancel'))
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  child: Center(
                                                                      child:
                                                                          Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                userDetails(
                                                                    doc['email'],
                                                                    doc['latitude'],
                                                                    doc['longitude'])));
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          );
                                  }
                                });
                          })
              //New
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
                    //  Navigator.pop(context);
                    await AuthService().logOut();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
