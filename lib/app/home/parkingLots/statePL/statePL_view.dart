import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/agrument/agrumentModel.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/get.dart';

class StatePL extends StatefulWidget {

  @override
  _StatePLState createState() => _StatePLState();
}

class _StatePLState extends State<StatePL> {
  int totalPointsUsed = 0;
  Argument argument;
  String _nameUser, _namePL, _addressPL;
  int _numberPhonePL, _deposit, _price, _penalty;

  @override
  void initState() {
    argument = Get.arguments;
    getInformation();
    super.initState();
  }

  getInformation() {
    users
    .doc(user.currentUser.uid)
        .get()
        .then((value){
          _nameUser = value.data()['name'];
    });
    parkingLot
    .doc(argument.idPL)
    .get()
    .then((value){
      final ParkingLotJson parkingLotJson = ParkingLotJson.fromJson(value.data());
      _namePL = parkingLotJson.namePL;
      _addressPL = parkingLotJson.address;
      _numberPhonePL = parkingLotJson.numberPhone;
      _deposit = parkingLotJson.deposit;
      _price = parkingLotJson.price;
      _penalty = parkingLotJson.penalty;
    });
  }

  Widget container({
  String content,
    int number
}){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
                width: 3,
                color: Colors.green
            )
        ),
        child: Column(
          children: [
            text(content),
            text(number.toString())
          ],
        ),
      ),
    );
  }

  void checkBooking(int totalPoints){
    if (totalPoints == argument.pointsUsed){
      showDialogAnnounce(
          content: 'Sorry, there aren\'t not any empty points'
      );
    } else {
      updateBooking();
    }
  }

  Future<void> updateBooking() async {
    await userState
    .add({
      'nameUser' : _nameUser,
      'idUser' : user.currentUser.uid,
      'namePL' : _namePL,
      'addressPL' : _addressPL,
      'idPL' : argument.idPL,
      'rentedTime' : argument.rentedTime,
      'returnTime' : argument.returnTime,
      'phoneNumbersPL' : _numberPhonePL,
      'deposit' : _deposit,
      'price' : _price,
      'penalty' : _penalty,
      'stateRent' : false,
      'notUsed' : false
    }).then((value) async {
      await userState.doc(value.id).update({'idUserState' : value.id});
      Get.offNamed(
          Routers.RESERVATIONDETAILS,
        arguments: value.id
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('State parking lot'),
        leading: Container(),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: parkingLot.doc(argument.idPL).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final ParkingLotJson _parkingLot = ParkingLotJson.fromJson(snapshot.data.data());
              return ListView(
                children: [
                  container(
                    content: 'Total points are empty',
                    number: _parkingLot.totalPoints - argument.pointsUsed
                  ),
                  container(
                      content: 'Total points are used',
                      number: argument.pointsUsed
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            color: Colors.green,
                            onPressed: () => Get.back(),
                            child: Text('Back'),
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          color: Colors.green,
                          onPressed: (){
                            checkBooking(_parkingLot.totalPoints);
                          },
                          child: Text('Book'),
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
      ),
    );
  }
}
