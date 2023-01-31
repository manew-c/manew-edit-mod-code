import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/Pages/userpage.dart';
import '../map.dart';
import 'package:flutter_application_1/Pages/informationPage.dart';

class userpage extends StatefulWidget {
  const userpage({super.key});

  @override
  State<userpage> createState() => _userpageState();
}

class _userpageState extends State<userpage> {
  final _formKey = GlobalKey<FormState>();
  final SERIES = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('เลือกผู้ใช้และหัววัด'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: 'ชื่อผู้บันทึก', icon: Icon(Icons.key)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your ชื่อผู้บันทึก';
                        }
                        return null;
                      },
                      onSaved: (value) => user.username = value!,
                      autofocus: true,
                      controller: SERIES,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: 'หัววัด', icon: Icon(Icons.key)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your หัววัด';
                        }
                        return null;
                      },
                      onSaved: (value) => user.detector = value!,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: 'รายละเอียดหัววัด', icon: Icon(Icons.key)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your รายละเอียดหัววัด';
                        }
                        return null;
                      },
                      onSaved: (value) => user.detectorinformation = value!,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                CollectionReference siteandprovind =
                                    FirebaseFirestore.instance
                                        .collection('ไซต์งาน');
                                siteandprovind
                                    .doc(Point
                                        .worksite) //Point.provinceค่ามันไม่ตามมาจากหน้าinformationอะ
                                    .collection('ผู้วัดรังสี')
                                    .doc(user.username)
                                    .collection('หัววัด')
                                    .doc(user.detector)
                                    .set({
                                  'รายละเอียดหัววัด': user.detectorinformation
                                });

                                /*
                                ยังไม่ได้ เราไม่มี collection ผู้ใช่มาก่อน มันไม่สร้างให้ ติดตรงcollection
                                
                                siteandprovind
                                    .doc(Point
                                        .province) //Point.provinceค่ามันไม่ตามมาจากหน้าinformationอะ
                                    .collection('ผู้วัดรังสี')
                                    .doc(user.username)
                                    .set({
                                  'หัววัด': user.detector,
                                  'รายละเอียดหัววัด': user.detectorinformation
                                });




                                 */

                                _formKey.currentState!.reset();
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapsPage()));
                            },
                            child: Text('บันทึก'),
                          )
                        ],
                      ),
                    )
                  ],
                ))));
  }
}

class _userclass {
  String username;
  String detector;
  String detectorinformation;
  _userclass(
      {required this.username,
      required this.detector,
      required this.detectorinformation});
}

_userclass user =
    _userclass(username: '', detector: '', detectorinformation: '');
