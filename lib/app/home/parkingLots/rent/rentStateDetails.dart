import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLots.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RentStateDetails extends StatefulWidget {

  @override
  _RentStateDetailsState createState() => _RentStateDetailsState();
}

class _RentStateDetailsState extends State<RentStateDetails> {
  String idUserState, _idPL;

  int _price, _pricePL, _penaltyPL;
  final format = DateFormat("dd-MM-yyyy HH:mm");
  Timestamp _returnTime; DateTime _returnTimeNew;

  @override
  void initState() {
    idUserState = Get.arguments;
    _getInforPL();
    super.initState();
  }

  _getInforPL(){
    userState
    .doc(idUserState)
        .get()
        .then((value){
          _returnTime = value.data()['returnTime'];
          _idPL = value.data()['idPL'];
       parkingLot
       .doc(_idPL)
           .get()
           .then((value2){
             _pricePL = value2.data()['price'];
             _penaltyPL = value2.data()['penalty'];
       });
    });
  }

  _getBill() {
    final DateTime _now = DateTime.now();
    userState
        .doc(idUserState)
        .get()
        .then((value) {
      var _userState = UserStateJson.fromJson(value.data());
      bill.add({
        'nameUser' : _userState.nameUser,
        'idUser' : _userState.idUser,
        'namePL' : _userState.namePL,
        'addressPL' : _userState.addressPL,
        'idPL' : _userState.idPL,
        'rentedTime' : _userState.rentedTime,
        'returnTime' : _now,
        'phoneNumbersPL' : _userState.phoneNumbersPL,
      }).then((value2) async {
        await addParkingLots.exceptPointPL(_userState.idPL);
        await _updateBill(_userState.rentedTime, _userState.returnTime, value2.id);
        await userState.doc(idUserState).delete().then((value3) => print('deleted'));
        Get.offNamed(
          Routers.BILLDETAILS,
          arguments: value2.id
        );
      });
    });
  }

  _updateBill(Timestamp rentTime, Timestamp returnTime, String idBill)async{
    final DateTime _now = DateTime.now();
    if (_now.isBefore(returnTime.toDate().add(Duration(minutes: 10)))){
      final _differentTime = _now.difference(rentTime.toDate());
      print(_differentTime);
      _price = _differentTime.inHours*_pricePL
          + ((_differentTime.inMinutes - _differentTime.inHours*60) > 10 ? 1 : 0)*_pricePL;
      bill.doc(idBill).update({
        'idBill' : idBill,
        'price' : _price,
        'timeUsed' : _differentTime.inMinutes
      });
    } else {
      final _differentTime = returnTime.toDate().difference(rentTime.toDate());
      _price = _differentTime.inHours*_pricePL
          + ((_differentTime.inMinutes - _differentTime.inHours*60) > 10 ? 1 : 0)*_pricePL;
      bill.doc(idBill).update({
        'idBill' : idBill,
        'price' : _price,
        'penalty' : _penaltyPL,
        'timeUsed' : _differentTime.inMinutes,
        'timeOverdue' : _now.difference(returnTime.toDate()).inMinutes
      });
    }
  }

  _addTime(){
    userState
    .doc(idUserState)
        .get()
        .then((value){
          _checkAddTime(value.data()['returnTime']);
    });
  }

  _checkAddTime(Timestamp returnTime){
    final DateTime _now = DateTime.now();
    if (_now.isBefore(returnTime.toDate().subtract(Duration(minutes: 30)))){
      _showMyDialog();
    } else {
      showDialogAnnounce(content: 'You must renew 30 minutes before the overdue');
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your end time'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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

  Widget dateTimeFieldReturn(){
    return DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          _returnTimeNew = DateTimeField.combine(date, time);
          print(_returnTimeNew);
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  _checkTimeChoose(){
    if (_returnTimeNew.isAfter(_returnTime.toDate().add(Duration(hours: 1)))){

    } else {
      showDialogAnnounce(content: 'Rental time is at least 1 hour');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rental details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.directions_car),
            onPressed: (){
              Get.toNamed(Routers.MYRENTSTATES);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: (){
                Get.toNamed(Routers.HOME);
              },
            ),
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userState.doc(idUserState).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final UserStateJson _userState = UserStateJson.fromJson(snapshot.data.data());
            final String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
            final String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text('Name customer: ${_userState.nameUser}'),
                      text('Name parking lot: ${_userState.namePL}'),
                      text(_userState.addressPL),
                      text('Phone numbers of PL: ${_userState.phoneNumbersPL.toString()}'),
                      text('From: $_rentedTime'),
                      text('To: $_returnTime'),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              onPressed: (){
                                _getBill();
                              },
                              child: text('Get Bill'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                color: Colors.green,
                                onPressed: (){
                                  _addTime();
                                },
                                child: text('Add time'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
