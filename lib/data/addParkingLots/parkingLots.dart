import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';

class AddParkingLots{
  void addParkingLot(){
    parkingLot
        .doc('N010')
        .update({
      'id' : 'N010',
      'namePL': 'Bãi đỗ học viện an ninh',
      'address': '125 Trần Phú, P. Văn Quán, Hà Đông, Hà Nội',
      'location': GeoPoint(20.982111, 105.791551),
      'price' : 12,
      'penalty' : 250,
      'deposit' : 60,
      'numberPhone' : 1010101010,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'},
    }); // Học viện an ninh
    parkingLot
        .doc('N009')
        .update({
      'id' : 'N009',
      'namePL': 'Bãi đỗ cao đẳng dược Hà Nội',
      'address': 'Số 1 Hoàng Đạo Thúy, Nhân Chính, Thanh Xuân, Hà Nội',
      'location': GeoPoint(21.005877, 105.803955),
      'price' : 17,
      'penalty' : 22,
      'deposit' : 130,
      'numberPhone' : 9999999999,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Cao đẳng dược Hà Nội
    parkingLot
        .doc('N008')
        .update({
      'id' : 'N008',
      'namePL': 'Bãi đỗ đại học công nghiệp',
      'address': 'Đường Cầu Diễn, Minh Khai, Bắc Từ Liêm, Hà Nội, Việt Nam',
      'location': GeoPoint(21.054660, 105.735153),
      'price' : 14,
      'penalty' : 150,
      'deposit' : 50,
      'numberPhone' : 8888888888,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Đại học công nghiệp
    parkingLot
        .doc('N007')
        .update({
      'id' : 'N007',
      'namePL': 'Bãi đỗ học viện ngoại giao',
      'address': 'Số 69 Chùa Láng, Láng Thượng, Đống Đa, Hà Nội, Việt Nam',
      'location': GeoPoint(21.023254, 105.806488),
      'price' : 15,
      'penalty' : 200,
      'deposit' : 50,
      'numberPhone' : 7777777777,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Học viện ngoại giao
    parkingLot
        .doc('N006')
        .update({
      'id' : 'N006',
      'namePL': 'Bãi đỗ kinh tế quốc dân',
      'address': '207 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội, Việt Nam',
      'location': GeoPoint(21.037313, 105.788925),
      'price' : 15,
      'penalty' : 45,
      'deposit' : 20,
      'numberPhone' : 6666666666,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Đại học kinh tế quốc dân
    parkingLot
        .doc('N005')
        .update({
      'id' : 'N005',
      'namePL': 'Bãi đỗ đại học thăng long',
      'address': 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
      'location': GeoPoint(20.976086, 105.815529),
      'price' : 15,
      'deposit' : 30,
      'penalty' : 400,
      'numberPhone' : 5555555555,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); //Đại học Thăng Long
    parkingLot
        .doc('N004')
        .update({
      'id' : 'N004',
      'namePL': 'Bãi đỗ đại học Hà Nội',
      'address': 'Km 9 Nguyễn Trãi, P. Văn Quán, Hà Đông, Hà Nội, Việt Nam',
      'location': GeoPoint(20.989433, 105.795311),
      'price' : 15,
      'penalty' : 30,
      'deposit' : 20,
      'numberPhone' : 4444444444,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Đại học Hà Nội
    parkingLot
        .doc('N003')
        .update({
      'id' : 'N003',
      'namePL': 'Bãi đỗ học viện báo chí và tuyên truyền',
      'address': '36 Xuân Thủy, Dịch Vọng Hậu, Cầu Giấy, Hà Nội, Việt Nam',
      'location': GeoPoint(21.037313, 105.788925),
      'price' : 12,
      'penalty' : 50,
      'deposit' : 34,
      'numberPhone' : 3333333333,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Học viện báo chí và tuyên truyền
    parkingLot
        .doc('N002')
        .update({
      'id' : 'N002',
      'namePL': 'Bãi đỗ học viện ngân hàng',
      'address': 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
      'location': GeoPoint(21.009023, 105.828590),
      'price' : 13,
      'penalty' : 30,
      'deposit' : 25,
      'numberPhone' : 2222222222,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); // Học viện ngân hàng
    parkingLot
        .doc('N001')
        .update({
      'id' : 'N001',
      'namePL': 'Bãi đỗ bách khoa',
      'address': 'Số 1, Đại Cồ Việt, Hai bà Trưng, Hà Nội',
      'location': GeoPoint(21.007235, 105.843125),
      'price' : 10,
      'penalty' : 30,
      'deposit' : 20,
      'numberPhone' : 111111111,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); //Bãi đỗ Bách Khoa
  }
  void getPoints(){
    parkingLot
        .get()
        .then((doc){
      doc.docs.forEach((element) {
        if(element.data()['allPoints'] == null){
          parkingLot
              .doc(element.id)
              .update({
            'allPoints' : {
              'A1' : false,
              'A2' : false,
              'B1' : false,
              'B2' : false,
              'C1' : false,
              'C2' : false,
              'D1' : false,
              'D2' : false,
            },
            'statePL' : true
          });
        }
      });
    });
  }
  void getStatePL() async {
    bool _statePL = false;
    await parkingLot
    .get()
        .then((value){
       value.docs.forEach((element) {
         var _allPoint = AllPoints.fromJson(element.data()['allPoints']);
         _checkState(_allPoint.toJson(), _statePL, element.id);
       });
    });
  }
  _checkState(Map<dynamic, dynamic> list, bool statePL, String id) async {
    await list.forEach((key, value) {
      if (value == false){
        statePL = true;
      }
    });
    _changeStatePL(id, statePL);
  }
  _changeStatePL(String id, bool state) {
    parkingLot
    .doc(id)
        .update({
      'statePL' : state
    }).then((value) => state = false);
  }
  void changePoint(String idPL, String namePoint, bool addOrDelete) async {
    Map<String, dynamic> _allPoints;
    await parkingLot
    .doc(idPL)
    .get()
    .then((value){
      _allPoints = value.data()['allPoints'];
    });
    await _allPoints.forEach((key, value) {
      if (key == namePoint){
        _allPoints[key] = addOrDelete;
        print(addOrDelete);
      }
    });
    parkingLot
    .doc(idPL)
    .update({
      'allPoints' : _allPoints
    });
  }
  void checkReservation(){
    final DateTime _now = DateTime.now();
    userState
    .get()
        .then((value){
       value.docs.forEach((element) async {
         var _userState = UserStateJson.fromJson(element.data());
         if (
         (_userState.notUsed == null) &&
         (_userState.stateRent == false) &&
             (_now.isAfter(_userState.rentedTime.toDate().add(Duration(minutes: 15))))
         ){
           await userState.doc(element.id).update({'notUsed' : true});
           await point.doc(_userState.idPoint).delete();
           changePoint(_userState.idPL, _userState.namePoint, false);
         } else if (
         (_now.isAfter(_userState.returnTime.toDate().add(Duration(minutes: 10)))) && (_userState.notUsed == null)
         ){
           await userState.doc(element.id).update({'notUsed' : true});
           await point.doc(_userState.idPoint).delete();
           changePoint(_userState.idPL, _userState.namePoint, false);
         }
       });
    });
  }
}

final addParkingLots = AddParkingLots();
