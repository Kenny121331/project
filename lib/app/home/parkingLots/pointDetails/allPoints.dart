import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/point/userStateData.dart';


class ShowAllPoints extends StatefulWidget {
  static final ROUTER = '/ShowAllPoint';
  String documentId;
  DateTime rentedTime, returntime;
  ShowAllPoints({this.documentId, this.rentedTime, this.returntime});
  @override
  _ShowAllPointsState createState() => _ShowAllPointsState(
    documentId: documentId,
    rentedTime: rentedTime,
    returntime: returntime
  );
}

class _ShowAllPointsState extends State<ShowAllPoints> {
  String documentId, _nameUser, _namePL, _addressPL;
  DateTime rentedTime, returntime;
  _ShowAllPointsState({this.documentId, this.returntime, this.rentedTime});
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference userState = FirebaseFirestore.instance.collection('userState');
  CollectionReference point = FirebaseFirestore.instance.collection('point');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth user = FirebaseAuth.instance;
  Future<void> _showMyDialog(String point) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to make a reservation at this $point point?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Yes'),
              onPressed: () {
                _check();
                //_makeReservation(point);
              },
            ),
          ],
        );
      },
    );
  }
  _makeReservation(String namePoint) async {
    await point
        .add({
      'idPL' : documentId,
      'namePoint' : namePoint,
      'rentedTime' : rentedTime,
      'returnTime' : returntime
    });
    
    userState
    .add({
      'nameUser' : _nameUser,
      'idUser' : user.currentUser.uid,
      'namePL' : _namePL,
      'addressPL' : _addressPL,
      'idPL' : documentId,
      'namePoint' : namePoint,
      'rentedTime' : rentedTime,
      'returnTime' : returntime
    }).then((value) => print('ok'));
  }
  _check(){

  }
  @override
  void initState() {
    _getInfor();
    super.initState();
  }

  _getInfor() async {
    await users
    .doc(user.currentUser.uid)
        .get()
        .then((value){
       _nameUser = value.data()['name'];
       print(_nameUser);
    });
    await parkingLot
    .doc(documentId)
    .get()
    .then((value){
      _namePL = value.data()['namePL'];
      _addressPL = value.data()['address'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All point'),
        actions: [
          IconButton(
            icon: Icon(Icons.directions),
            onPressed: (){
              _showMyDialog('hihi');
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: parkingLot.doc(documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              //Map<String, dynamic> data = snapshot.data.data();
              var _parkingLot = ParkingLotJson.fromJson(snapshot.data.data());
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: arrangePoint.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            _showMyDialog(arrangePoint[index].point);
                          },
                          child: Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  arrangePoint[index].point,
                                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                                ),
                              )
                          ),
                        );
                      }
                  ),
                )
              );
            }
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
      ),
    );
  }
}

