import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/detailsPL.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:get/get.dart';

class FiveNearstPL extends StatelessWidget {
  Widget text(String text, double size, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color),
    );
  }
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '5 nearest parking lots'
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: parkingLot.orderBy('distance', descending: false).limit(5).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                var _parkingLot = ParkingLotJson.fromJson(document.data());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new GestureDetector(
                    onTap: (){
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Details(
                      //     documentId: _parkingLot.id,
                      //   ))
                      // );
                      Get.to(DetailsPL(
                        documentId: _parkingLot.id,
                      ));
                    },
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                              width: 3,
                              color: _parkingLot.statePL ? Colors.green : Colors.red
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(_parkingLot.namePL, 21, Colors.black),
                            text(_parkingLot.address, 16, Colors.grey),
                            text('Distance: ${_parkingLot.distance} km', 16, Colors.grey)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
    );
  }
}
