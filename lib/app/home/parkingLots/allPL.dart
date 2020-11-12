import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detailsPL.dart';

class AllParkingLots extends StatelessWidget {
  static final ROUTER = '/AllParkingLots';
  CollectionReference parkingLots = FirebaseFirestore.instance.collection('parkingLot');
  Map<dynamic, dynamic> parkingLot = {};
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
                  return ListTile(
                    title: Text(document.data()['namePL']),
                    trailing: Icon(Icons.arrow_right),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Details(
                            documentId: document.data()['id'],
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