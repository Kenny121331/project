import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/bill/billDetails.dart';
import 'package:flutter_app_parkinglots/app/home/home.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/MyRentStates.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLots.dart';
import 'package:flutter_app_parkinglots/data/point/PointJson.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:intl/intl.dart';


class RentStateDetails extends StatefulWidget {
  String idUserState;
  RentStateDetails({this.idUserState});

  @override
  _RentStateDetailsState createState() => _RentStateDetailsState(
      idUserState: idUserState
  );
}

class _RentStateDetailsState extends State<RentStateDetails> {
  String idUserState, _idPL, _namePoint;
  _RentStateDetailsState({this.idUserState});
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference userState = FirebaseFirestore.instance.collection('userState');
  CollectionReference point = FirebaseFirestore.instance.collection('point');
  CollectionReference bill = FirebaseFirestore.instance.collection('bill');
  var addParkingLot = AddParkingLots();
  int _price, _pricePL, _penaltyPL;
  final format = DateFormat("dd-MM-yyyy HH:mm");
  Timestamp _returnTime, _rentedTime; DateTime _returnTimeNew;
  final DateTime _now = DateTime.now();
  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 21),
      ),
    );
  }
  @override
  void initState() {
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
          _rentedTime = value.data()['rentedTime'];
          _namePoint = value.data()['namePoint'];
       parkingLot
       .doc(_idPL)
           .get()
           .then((value2){
             _pricePL = value2.data()['price'];
             _penaltyPL = value2.data()['penalty'];
       });
    });
  }
  Future<void> _announce(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.green,
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _getBill() {
    userState
        .doc(idUserState)
        .get()
        .then((value) async {
      var _userState = UserStateJson.fromJson(value.data());
      await addParkingLot.changePoint(_userState.idPL, _userState.namePoint, false);
      await point.doc(_userState.idPoint).delete().then((value) => print('deleted point'));
      bill.add({
        'nameUser' : _userState.nameUser,
        'idUser' : _userState.idUser,
        'namePL' : _userState.namePL,
        'addressPL' : _userState.addressPL,
        'idPL' : _userState.idPL,
        'namePoint' : _userState.namePoint,
        'rentedTime' : _userState.rentedTime,
        'returnTime' : _userState.returnTime,
        'phoneNumbersPL' : _userState.phoneNumbersPL,
      }).then((value2) async {
        await _updateBill(_userState.rentedTime, _userState.returnTime, value2.id);
        await userState.doc(idUserState).delete().then((value3) => print('deleted'));
        Navigator.push(context, MaterialPageRoute(builder: (context) => BillDetails(
          idBill: value2.id,
        )));
      });
    });
  }
  _updateBill(Timestamp rentTime, Timestamp returnTime, String idBill)async{
    _price = returnTime.toDate().difference(rentTime.toDate()).inHours*_pricePL;
    if (_now.isBefore(returnTime.toDate().add(Duration(minutes: 10)))){
      bill.doc(idBill).update({
        'idBill' : idBill,
        'price' : _price
      });
    } else {
      bill.doc(idBill).update({
        'idBill' : idBill,
        'price' : _price,
        'penalty' : _penaltyPL
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
    if (_now.isBefore(returnTime.toDate().subtract(Duration(minutes: 30)))){
      _showMyDialog();
    } else {
      //_showMyDialog();
      _announce('You must renew 30 minutes before the overdue');
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
  _updateTime()async{
    await userState.doc(idUserState).get()
    .then((value){
      point.doc(value.data()['idPoint'])
          .update({'returnTime' : _returnTimeNew});
    });
    userState
        .doc(idUserState)
        .update({
      'returnTime' : _returnTimeNew
    }).then((value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RentStateDetails(
          idUserState: idUserState,
        ))
    ));
  }
  _checkPoint(){
    point
        .where('idPL', isEqualTo: _idPL)
        .where('namePoint', isEqualTo: _namePoint)
        .get()
        .then((value){
      if (value.docs.length > 0){
        value.docs.forEach((element) {
          var _point = PointJson.fromJson(element.data());
          if (
          (_returnTime.toDate().isBefore(_point.rentedTime.toDate()) &&
              _returnTimeNew.isBefore(_point.rentedTime.toDate().subtract(Duration(minutes: 20)))) ||
              _returnTime.toDate().isAfter(_point.rentedTime.toDate()) &&
                  _returnTimeNew.isAfter(_point.rentedTime.toDate())
          ){
            print('ok');
            _updateTime();
          } else {
            print('cancel');
            _announce('This time has been used by someone else');
          }
        });
      }
    });
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
      _checkPoint();
    } else {
      _announce('Rental time is at least 1 hour');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Rental details'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: (){
            Navigator.pushNamed(context, Home.ROUTER);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.directions_car),
            onPressed: (){
              Navigator.pushNamed(context, MyRentStates.ROUTER);
            },
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
            var _userState = UserStateJson.fromJson(snapshot.data.data());
            String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
            String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text('Name customer: ${_userState.nameUser}'),
                      text('Name parking lot: ${_userState.namePL}'),
                      text('Name point: ${_userState.namePoint}'),
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
                                  //_showMyDialog();
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
