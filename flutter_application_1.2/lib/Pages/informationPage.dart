import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/Pages/userpage.dart';

class informationPage extends StatefulWidget {
  const informationPage({super.key});

  @override
  State<informationPage> createState() => _informationPageState();
}

class _informationPageState extends State<informationPage> {
  final _formKey = GlobalKey<FormState>();
  final SERIES = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลPROJECT'),
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
                          labelText: 'ไซต์งาน', icon: Icon(Icons.key)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your ไซต์งาน';
                        }
                        return null;
                      },
                      onSaved: (value) => Point.worksite = value!,
                      autofocus: true,
                      controller: SERIES,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: 'จังหวัด', icon: Icon(Icons.key)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your จังหวัด';
                        }
                        return null;
                      },
                      onSaved: (value) => Point.province = value!,
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
                                    .doc(Point.worksite)
                                    .set({'จังหวัด': Point.province});
                                //.collection('ไซต์งาน').doc(Point.worksite).set(Point.province)
                                /*
                                CollectionReference siteandprovind =
                                    FirebaseFirestore.instance
                                        .collection('project1');
                                siteandprovind.add({
                                  'ไซต์งาน': Point.worksite,
                                  'จังหวัด': Point.province
                                }); */

                                _formKey.currentState!.reset();
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => userpage()));
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

class _pointclass {
  String worksite;
  double number;
  String province;
  _pointclass(
      {required this.worksite, required this.number, required this.province});
}

_pointclass Point = _pointclass(worksite: '', number: 0, province: '');
