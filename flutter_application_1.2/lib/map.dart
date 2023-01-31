import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/survey.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/Pages/informationPage.dart';
import 'package:flutter_application_1/Pages/userpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsPage extends StatefulWidget {
  MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late Position userlocation;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userlocation = await Geolocator.getCurrentPosition();
    return userlocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Google Maps'),
      ),
      body: FutureBuilder(
          future: _getLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(userlocation.latitude, userlocation.longitude),
                    zoom: 15),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('กำลังโหลด'),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              mapController.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(userlocation.latitude, userlocation.longitude), 18));
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        'Your location!\nlat: ${userlocation.latitude} long: ${userlocation.longitude} '),
                    content: TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: InputDecoration(hintText: 'Enter your dose'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your dose';
                        }
                        return null;
                      },
                      onSaved: (value) => dose = value!,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          CollectionReference siteandprovind =
                              FirebaseFirestore.instance.collection('ไซต์งาน');
                          siteandprovind
                              .doc(Point
                                  .worksite) //Point.provinceค่ามันไม่ตามมาจากหน้าinformationอะ
                              .collection('ผู้วัดรังสี')
                              .doc(user.username)
                              .collection('หัววัด')
                              .doc(user.detector)
                              .collection('ชื่อจุด')
                              .doc('จุดt-1')
                              .set({
                            'dose': dose,
                            'lat': userlocation.latitude,
                            'long': userlocation.longitude
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => survey()));
                        },
                        child: Center(child: Text("Submit")),
                      )
                    ],
                  );
                },
              );
            },
            label: Text("Send Location"),
            icon: Icon(Icons.near_me),
          ),
        ],
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop();
  }
}

/*
ตัวแปร
${userlocation.latitude} long: ${userlocation.longitude
*/
dynamic dose = 0;
