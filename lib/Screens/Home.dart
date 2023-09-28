import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shield/Database/Database_Model.dart';
import 'package:shield/Location/Location.dart';
import 'package:shield/Reusable/Reusable.dart';

import '../Database/Database.dart';
import '../Location/SMS.dart';

class Home extends StatefulWidget {
  final String Name;
  const Home({Key? key, required this.Name}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = MethodChannel('sendSms');
  List<UserModel> user = [];
  bool isLoading = false;
  List<ContactsModel> contactModel = [];
  List<String> contacts = [];

  TextEditingController lattitude = TextEditingController();
  TextEditingController longtitude = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController locality = TextEditingController();
  TextEditingController address = TextEditingController();

  Position? currentLocation;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  void getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    user = await Database.getUser();
    setState(() {
      isLoading = false;
    });
  }

  void deleteUser() async {
    await Database.deleteUser(widget.Name);
  }

  Future<void> getCurrentlocation() async {
    checkLocationPermission();
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    if (isDeviceConnected == true) {
      currentLocation = await GetLocation.getLocation();
      lattitude.text = (currentLocation!.latitude).toString();
      longtitude.text = (currentLocation!.longitude).toString();
      List<Placemark> placemark = await placemarkFromCoordinates(
          currentLocation!.latitude, currentLocation!.longitude);
      countryName.text = placemark[0].country!;
      locality.text = placemark[0].locality!;
      address.text =
          "${placemark[0].street} ${placemark[0].locality} ${placemark[0].subLocality} ${placemark[0].administrativeArea} ${placemark[0].postalCode}";
    } else {
      currentLocation = await GetLocation.getLocation();
      lattitude.text = (currentLocation!.latitude).toString();
      longtitude.text = (currentLocation!.longitude).toString();
      countryName.clear();
      locality.clear();
      address.clear();
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    getCurrentlocation();
    getUserDetails();
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        if (mounted) {
          setState(() {
            isAlertSet = true;
          });
        }
      }
    });
  }

  Future<int> getContactsDetails() async {
    final model = await Database.getContact();
    setState(() {
      contactModel = model;
    });
    return contactModel.length;
  }

  checkSMSPermission() async {
    var status = await Permission.sms.status.isGranted;
    if (!status) {
      await Permission.sms.request();
      return true;
    } else {
      return true;
    }
  }

  checkLocationPermission() async {
    var status = await Permission.location.isGranted;
    if (!status) {
      await Permission.location.request();
      return true;
    } else {
      return true;
    }
  }

  callWithSMS() async {
    List<ContactsModel> contactsModel = await Database.getContact();
    List<UserModel> userModel = await Database.getUser();
    String link =
        "https://www.google.com/maps/place/${lattitude.text},${longtitude.text}/@${lattitude.text},${longtitude.text}/data=!3m1!4b1";
    String Message = "${userModel[0].FullName}\n"
        "${userModel[0].Mobile}\n"
        "${userModel[0].Message!}\n"
        "$link";
    print(Message);

    for (int i = 0; i < contactsModel.length; i++) {
      await SMS.SendSMS(Message, contactsModel[i].Contacts!, context);
    }
  }

  callWithoutSMS() async {
    List<ContactsModel> contactsModel = await Database.getContact();
    List<UserModel> userModel = await Database.getUser();
    String link =
        "https://www.google.com/maps/place/${lattitude.text},${longtitude.text}/@${lattitude.text},${longtitude.text}/data=!3m1!4b1";
    String Message = "${userModel[0].FullName}\n"
        "${userModel[0].Mobile}\n"
        "${userModel[0].Message!}\n"
        "$link";
    for (int i = 0; i < contactsModel.length; i++) {
      await SMS.SendSMS(Message, contactsModel[i].Contacts!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: getCurrentlocation,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),

                // Current Location Text
                const Center(
                  child: Text(
                    "Current Location",
                    style: TextStyle(
                        fontFamily: 'Cambria',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.deepOrange),
                  ),
                ),

                // Lattitude Text Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextField(
                      style: const TextStyle(
                        fontFamily: 'Cambria',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: lattitude,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Lattitude",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      )),
                ),

                // Longtitude Text Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: longtitude,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Longtitude",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // Country Name Text Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: countryName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Country Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // Locality Text Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: locality,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Locality",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // Address Text Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.topCenter,
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: address,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // Get Location Button
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: 40,
                      right: 40,
                      bottom: 10),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!mounted) {
                        return;
                      }
                      await getCurrentlocation();
                    },
                    child: isLoading
                        ? Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            width: 20,
                            height: 30,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Get Location"),
                  ),
                ),

                // Finger Image
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      if (lattitude.text.isEmpty && longtitude.text.isEmpty) {
                        Reusable.Success(
                            "Latitude & Longitude must not be Empty", context);
                      } else {
                        int length = await getContactsDetails();
                        if (length == 0) {
                          Reusable.Failure(
                              "Atleast add one contact to Send SMS...",
                              context);
                        } else {
                          bool result = await checkSMSPermission();
                          if (result) {
                            if (isDeviceConnected) {
                              callWithoutSMS();
                            } else {
                              callWithSMS();
                            }
                          } else {
                            Reusable.Failure(
                                "Please Accept SMS Permission", context);
                          }
                        }
                      }
                    },
                    radius: 60,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage:
                          AssetImage("assets/images/finger1_low.png"),
                      radius: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
