import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/reservationDetails.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/point/PointJson.dart';
import 'package:get/get.dart';

class ShowAllPoints extends StatefulWidget {
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
  final List<ArrangePoint2> arrangePoint2 = [
    ArrangePoint2(point: 'A1', state: true),
    ArrangePoint2(point: 'A2', state: true),
    ArrangePoint2(point: 'B1', state: true),
    ArrangePoint2(point: 'B2', state: true),
    ArrangePoint2(point: 'C1', state: true),
    ArrangePoint2(point: 'C2', state: true),
    ArrangePoint2(point: 'D1', state: true),
    ArrangePoint2(point: 'D2', state: true),
  ];

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
        await Get.back();
        Get.off(ReservationDetails(
          idUserState: value2.id,
        ));
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
    print(documentId);
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
            print('ok');
          } else {
            print('cancel');
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
          showDialogChoose(
              content: 'Would you like to make a reservation at this $namePoint point?',
              onConfirm: () => _makeReservation(namePoint),
              textCancel: 'No',
              textConfirm: 'Yes'
          );
        } else {
          showDialogAnnounce(
              content: 'You can\'t book this $namePoint point'
          );
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
    final double width = MediaQuery.of(context).size.width;
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('All point'),
        actions: [
          IconButton(
            icon: Icon(Icons.directions),
            onPressed: (){
              _checkColor();
            },
          )
        ],
      ),
      body: Container(
          width: isPortrait ? width : width/2,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
                itemCount: arrangePoint2.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isPortrait ? width/2 : width/4,
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

