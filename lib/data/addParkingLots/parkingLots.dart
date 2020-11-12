
import 'package:cloud_firestore/cloud_firestore.dart';

class AddParkingLots{
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference userState = FirebaseFirestore.instance.collection('userState');
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
      'address': 'Số 69 Chùa Láng, Láng Thượng, Đống Đa, Hà Nội 100000, Việt Nam',
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
      'address': 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
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
      'Giá một giờ thuê' : 15,
      'Giá phạt quá hạn' : 30,
      'tổng số chỗ' : 400,
      'numberPhone' : 5555555555,
      //'allPoint' : {'A1', 'A2', 'A3', 'B1', 'B2', 'B3'}
    }); //Đại học Thăng Long
    parkingLot
        .doc('N004')
        .update({
      'id' : 'N004',
      'namePL': 'Bãi đỗ dại học Hà Nội',
      'address': 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
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
      'address': 'Số 12 Chùa Bộc, Quang Trung, Đống Đa, Hà Nội',
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
  void deleteReservation(){
    DateTime time = DateTime.now();
    var allPoints = {};
    userState
        .get().then((value){
      if (value.docs.length != null){
        value.docs.forEach((element) {
          print('checked');
          if (element.data()['reserveTime'] != null){
            print('check day: ${element.data()['cancelTime']['day'] < time.day}');
            if(element.data()['cancelTime']['day'] < time.day){
              print(element.data()['cancelTime']['day']);
              _deleteUserState(element.data()['idParkingLot'], element.id, element.data()['vị trí'], allPoints);
            } else if(element.data()['cancelTime']['day'] == time.day) {
              print('check hour: ${element.data()['cancelTime']['hour'] < time.hour}');
              if (element.data()['cancelTime']['hour'] < time.hour){
                print(element.data()['cancelTime']['hour']);
                _deleteUserState(element.data()['idParkingLot'], element.id, element.data()['vị trí'], allPoints);
              } else if (element.data()['cancelTime']['hour'] == time.hour){
                if (element.data()['cancelTime']['minute'] < time.minute){
                  _deleteUserState(element.data()['idParkingLot'], element.id, element.data()['vị trí'], allPoints);
                } else{
                  print('cancel');
                }
              }
            }
          }
        });
      }
    });
  }
  _deleteUserState(String idPL, String idState, String point, Map<dynamic, dynamic> allPoint){
    parkingLot
        .doc(idPL)
        .get()
        .then((value){
      allPoint = value.data()['allPoints'];
    }).then((value2){
      allPoint.forEach((key, value) {
        if (key == point){
          allPoint[key] = false;
        }
        parkingLot
            .doc(idPL)
            .update({
          'allPoints' : allPoint
        }).then((value) => userState.doc(idState).delete()
            .then((value) => allPoint.clear()));
      });
    });
  }
}