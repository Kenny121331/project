import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';

import 'detailsPL.dart';

class AllParkingLots extends StatelessWidget {
  static final ROUTER = '/AllParkingLots';
  CollectionReference parkingLots = FirebaseFirestore.instance.collection('parkingLot');
  //Map<dynamic, dynamic> parkingLot = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All parking lots'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: parkingLots.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document){
                  var _parkingLot = ParkingLotJson.fromJson(document.data());
                  return ListTile(
                    title: Text(_parkingLot.namePL),
                    trailing: Icon(Icons.arrow_right),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Details(
                            documentId: _parkingLot.id,
                          ))
                      );
                    },
                  );
                }).toList()
            );
          }
      ),
    );
  }
}