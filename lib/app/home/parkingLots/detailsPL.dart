import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/agrument/agrumentModel.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailsPL extends StatefulWidget {
  final String documentId;
  DetailsPL({this.documentId});

  @override
  _DetailsPLState createState() => _DetailsPLState(
    documentId: documentId
  );
}

class _DetailsPLState extends State<DetailsPL> {
  final format = DateFormat("dd-MM-yyyy HH:mm");
  final DateTime _now = DateTime.now();
  DateTime rentedTime, returnTime;
  final String documentId;
  _DetailsPLState({this.documentId});

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
                Get.back();
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
      if (rentedTime.isBefore(_now.subtract(Duration(minutes: 5)))){
        showDialogAnnounce(
          content: 'You have hire the time after now'
        );
      } else {
        if (returnTime.isBefore(rentedTime.add(Duration(hours: 1)))){
          showDialogAnnounce(
              content: 'You have hired at least one hours'
          );
        } else {
          makeArgument();
        }
      }
    } else {
      showDialogAnnounce(
          content: 'You have choose your time'
      );
    }
  }

  Future<void> makeArgument() async {
    Get.back();
    int pointsUsed = 0;
    await userState
    .where('idPL', isEqualTo: documentId)
    .get()
    .then((value){
      value.docs.forEach((element) {
        final UserStateJson userStateJson = UserStateJson.fromJson(element.data());
        if (rentedTime.isAfter(userStateJson.rentedTime.toDate().add(Duration(minutes: 20))) ||
            returnTime.isBefore(userStateJson.rentedTime.toDate().subtract(Duration(minutes: 20)))
        ){
          // don't do anything :))
        } else {
          pointsUsed++;
        }
      });
    });
    Get.toNamed(
        Routers.STATEPL,
        arguments: Argument(
            idPL: documentId,
            rentedTime: rentedTime,
            returnTime: returnTime,
            pointsUsed: pointsUsed
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                var _parkingLot = ParkingLotJson.fromJson(snapshot.data.data());
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          text(_parkingLot.namePL),
                          text(_parkingLot.address),
                          richText(
                              text1: 'Parking lot\'s phone number: ',
                              text2: '${_parkingLot.numberPhone}'
                          ),
                          richText(
                              text1: 'Price per hour rental: ',
                              text2: '${_parkingLot.price}k vnd'
                          ),
                          richText(
                              text1: 'Overdue penalty price: ',
                              text2: '${_parkingLot.penalty}k vnd'
                          ),
                          richText(
                              text1: 'Booking price: ',
                              text2: '${_parkingLot.deposit}k vnd'
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Center(
                              child: RaisedButton(
                                color: Colors.green,
                                onPressed: _showMyDialog,
                                child: Text(
                                    'Choose the rental period'
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
