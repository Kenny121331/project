import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/reservationDetails.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/point/PointJson.dart';


class ShowAllPoints extends StatefulWidget {
  static final ROUTER = '/ShowAllPoint';
  String documentId;
  DateTime rentedTime, returntime;
  ShowAllPoints({this.documentId, this.rentedTime, this.returntime});
  @override
  _ShowAllPointsState createState() => _ShowAllPointsState(
    documentId: documentId,
    rentedTime: rentedTime,
    returnTime: returntime,
  );
}

class _ShowAllPointsState extends State<ShowAllPoints> {

  String documentId, _nameUser, _namePL, _addressPL;
  DateTime rentedTime, returnTime;
  int _numberPhonePL, _deposit, _price, _penalty;
  _ShowAllPointsState({this.documentId, this.returnTime, this.rentedTime});
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
              color: Colors.green,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              color: Colors.green,
              child: Text('Yes'),
              onPressed: () {
                //_check();
                _makeReservation(point);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showError(String point) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You can\'t book this $point point'),
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
  _makeReservation(String namePoint) async {
    point
        .add({
      'idPL' : documentId,
      'namePoint' : namePoint,
      'rentedTime' : rentedTime,
      'returnTime' : returnTime,
    }).then((value)async{
      await point.doc(value.id).update({'idPoint' : value.id});
      userState
          .add({
        'nameUser' : _nameUser,
        'idUser' : user.currentUser.uid,
        'namePL' : _namePL,
        'addressPL' : _addressPL,
        'idPL' : documentId,
        'namePoint' : namePoint,
        'rentedTime' : rentedTime,
        'returnTime' : returnTime,
        'phoneNumbersPL' : _numberPhonePL,
        'idPoint' : value.id,
        'deposit' : _deposit,
        'price' : _price,
        'penalty' : _penalty,
        'stateRent' : false
      }).then((value2) async {
        await userState.doc(value2.id).update({'idUserState' : value2.id});
        await Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReservationDetails(
              idUserState: value2.id,
            ))
        );
      });
    });
  }

  @override
  void initState() {
    _getInfor();
    _checkColor();
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
      var _parkingLot = ParkingLotJson.fromJson(value.data());
      _namePL = _parkingLot.namePL;
      _addressPL = _parkingLot.address;
      _numberPhonePL = _parkingLot.numberPhone;
      _deposit = _parkingLot.deposit;
      _price = _parkingLot.price;
      _penalty = _parkingLot.penalty;
    });
  }
  _checkColor() async {
    point
        .where('idPL', isEqualTo: documentId)
        .get()
        .then((value){
      if (value.docs.length > 0){
        value.docs.forEach((element) {
          Timestamp time = element.data()['returnTime'];
          print(time.toDate());
          print(element.data()['namePoint']);
          var _point = PointJson.fromJson(element.data());
          if (rentedTime.isAfter(_point.returnTime.toDate().add(Duration(minutes: 20))) ||
              returnTime.isBefore(_point.rentedTime.toDate().subtract(Duration(minutes: 20)))){
            print(rentedTime);
            print(_point.returnTime.toDate().add(Duration(minutes: 20)));
            print(rentedTime.isAfter(_point.returnTime.toDate().add(Duration(minutes: 20))));
            print(returnTime.isBefore(_point.rentedTime.toDate().subtract(Duration(minutes: 20))));
            print('ok');
          } else {
            print('cancel');
            print(_point.namePoint);
            arrangePoint2.forEach((element2) {
              if (element2.point == _point.namePoint){
                setState(() {
                  element2.state = false;
                });
              }
            });
          }
        });
      }
    });
  }


  Widget container(String namePoint, String idPL, bool color){
    return GestureDetector(
      onTap: (){
        if (color){
          _showMyDialog(namePoint);
        } else {
          _showError(namePoint);
        }
      },
      child: Container(
          color: color ? Colors.blue : Colors.red,
          child: Center(
            child: Text(
              namePoint,
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
          )
      ),
    );
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
              _checkColor();
              //_check();
              // _showMyDialog('hihi');
            },
          )
        ],
      ),
      body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
                itemCount: arrangePoint2.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                itemBuilder: (context, index) {
                  return container(arrangePoint2[index].point, documentId, arrangePoint2[index].state);
                }
            ),
          )
      ),
    );
  }
}

