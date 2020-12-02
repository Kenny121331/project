import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/pointDetails/allPoints.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:intl/intl.dart';



class Details extends StatefulWidget {
  static final ROUTER = '/Detail';
  final String documentId;
  Details({this.documentId});
  @override
  _DetailsState createState() => _DetailsState(
    documentId: documentId
  );
}

class _DetailsState extends State<Details> {
  final format = DateFormat("dd-MM-yyyy HH:mm");
  DateTime _now = DateTime.now();
  DateTime rentedTime, returnTime;
  final String documentId;
  _DetailsState({this.documentId});
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference point = FirebaseFirestore.instance.collection('point');
  final FirebaseAuth user = FirebaseAuth.instance;
  Widget richText(String text1, int text2, String text3) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: text1, style: TextStyle(fontSize: 21, color: Colors.black)),
              TextSpan(text: '$text2', style: TextStyle(fontSize: 21, color: Colors.black)),
              TextSpan(text: text3, style: TextStyle(fontSize: 21, color: Colors.black)),
            ]
        ),
      ),
    );
  }
  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 21),
      ),
    );
  }
  Widget dateTimeFieldRent(){
    return DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2015),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2025));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          rentedTime = DateTimeField.combine(date, time);
          print(rentedTime);
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }
  Widget dateTimeFieldReturn(){
    return DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2015),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2025));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          returnTime = DateTimeField.combine(date, time);
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose your rental period'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Start time'),
                dateTimeFieldRent(),
                Text('End time'),
                dateTimeFieldReturn()
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.green,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              color: Colors.green,
              child: Text('Approve'),
              onPressed: () {
                _checkTimeChoose();
              },
            ),
          ],
        );
      },
    );
  }
  _checkTimeChoose() async {
    if (rentedTime != null && rentedTime != null){
      //print('rent: $rentedTime'); print('now: $_now');
      if (rentedTime.isBefore(_now.subtract(Duration(minutes: 5)))){
        _errorTimeChoose('You have hire the time after now');
      } else {
        if (returnTime.isBefore(rentedTime.add(Duration(hours: 1)))){
          _errorTimeChoose('You have hired at least one hours');
        } else {
          await Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowAllPoints(
            documentId: documentId,
            rentedTime: rentedTime,
            returntime: returnTime,
          )));
          //await _chooseColor();
          //print(_color);
        }
      }
    } else {
      _errorTimeChoose('You have choose your time');
    }
  }
  Future<void> _errorTimeChoose(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  CollectionReference duration = FirebaseFirestore.instance.collection('duration');
  _checkDuration(){
    final next = _now.add(Duration(hours: 4, minutes: 20));
    Duration _duration = next.difference(_now);
    print(next.difference(_now));
    // duration.add({
    //   'duration' : _duration.inMinutes
    // }).then((value) => print('add duration')).catchError((onError) => print('error: $onError'));
    print(6%0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Parking lot'
          ),

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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(_parkingLot.namePL),
                            text(_parkingLot.address),
                            richText('Số điện thoại: ', _parkingLot.numberPhone, null),
                            richText('Giá một giờ thuê ', _parkingLot.price, ' nghìn'),
                            richText('Giá phạt quá hạn ', _parkingLot.penalty, ' nghìn'),
                            richText('Giá đặt chỗ ', _parkingLot.deposit, ' nghìn'),

                            Padding(
                              padding: const EdgeInsets.only(top: 80),
                              child: Center(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: _showMyDialog,
                                  child: Text(
                                      'Find empty point'
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 80),
                              child: Center(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: _checkDuration,
                                  child: Text(
                                      'Duration'
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
        )
    );
  }
}
