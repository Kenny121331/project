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
      'totalPoints' : 13
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
      'totalPoints' : 25
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
      'totalPoints' : 17
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
      'totalPoints' : 5
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
      'totalPoints' : 7
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
      'totalPoints' : 20
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
      'totalPoints' : 12
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
      'totalPoints' : 17
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
      'totalPoints' : 23
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
      'totalPoints' : 50
    }); //Bãi đỗ Bách Khoa
    addPointsUsed();
  }

  void addPointsUsed(){
    parkingLot
    .get()
        .then((value){
       value.docs.forEach((element) {
         if (element.data()['pointsUsed'] == null){
           parkingLot.doc(element.id).update(
               {'pointsUsed' : 0}
           );
         }
       });
    });
  }

  void checkCurrentState(){
    parkingLot
    .get()
        .then((value){
       value.docs.forEach((element) {
         final ParkingLotJson parkingLotJson = ParkingLotJson.fromJson(element.data());
         if (parkingLotJson.totalPoints > parkingLotJson.pointsUsed){
           parkingLot.doc(parkingLotJson.id).update({
             'statePL' : true
           });
         } else {
           parkingLot.doc(parkingLotJson.id).update({
             'statePL' : false
           });
         }
       });
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
         (!_userState.notUsed) &&
         (!_userState.stateRent) &&
             (_now.isAfter(_userState.rentedTime.toDate().add(Duration(minutes: 15))))
         ){
           exceptPointPL(_userState.idPL);
           await userState.doc(element.id).update({'notUsed' : true});
         } else if (
         (_now.isAfter(_userState.returnTime.toDate().add(Duration(minutes: 10)))) &&
             (!_userState.notUsed) && (_userState.stateRent)
         ){
           exceptPointPL(_userState.idPL);
           await userState.doc(element.id).update({'notUsed' : true});
         }
       });
    });
  }

  void exceptPointPL(String idPL){
    parkingLot
    .doc(idPL)
        .get()
        .then((value){
       parkingLot.doc(idPL).update({
         'pointsUsed' : value.data()['pointsUsed'] - 1
       });
    });
  }

  void addPointPL(String idPL){
    parkingLot
        .doc(idPL)
        .get()
        .then((value){
      parkingLot.doc(idPL).update({
        'pointsUsed' : value.data()['pointsUsed'] + 1
      });
    });
  }
}

final addParkingLots = AddParkingLots();
