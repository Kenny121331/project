
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingLotJson {
  bool statePL;
  String address;
  String namePL;
  AllPoints allPoints;
  int price;
  String id;
  int deposit;
  int numberPhone;
  int penalty;
  GeoPoint geoPoint;
  double distance;

  ParkingLotJson(
      {this.statePL,
        this.address,
        this.namePL,
        this.allPoints,
        this.price,
        this.id,
        this.deposit,
        this.numberPhone,
        this.penalty,
        this.geoPoint,
        this.distance
      });

  ParkingLotJson.fromJson(Map<String, dynamic> json) {
    statePL = json['statePL'];
    address = json['address'];
    namePL = json['namePL'];
    allPoints = json['allPoints'] != null
        ? new AllPoints.fromJson(json['allPoints'])
        : null;
    price = json['price'];
    id = json['id'];
    deposit = json['deposit'];
    numberPhone = json['numberPhone'];
    penalty = json['penalty'];
    geoPoint = json['location'] != null
        ? json['location']
        : null;
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statePL'] = this.statePL;
    data['address'] = this.address;
    data['namePL'] = this.namePL;
    if (this.allPoints != null) {
      data['allPoints'] = this.allPoints.toJson();
    }
    data['price'] = this.price;
    data['id'] = this.id;
    data['deposit'] = this.deposit;
    data['numberPhone'] = this.numberPhone;
    data['penalty'] = this.penalty;
    if (this.geoPoint != null) {
      data['location'] = this.geoPoint;
    }
    data['distance'] = this.distance;
    return data;
  }
}

class AllPoints {
  bool b2;
  bool c2;
  bool a2;
  bool c1;
  bool a1;
  bool d1;
  bool d2;
  bool b1;

  AllPoints(
      {this.b2, this.c2, this.a2, this.c1, this.a1, this.d1, this.d2, this.b1});

  AllPoints.fromJson(Map<String, dynamic> json) {
    b2 = json['B2'];
    c2 = json['C2'];
    a2 = json['A2'];
    c1 = json['C1'];
    a1 = json['A1'];
    d1 = json['D1'];
    d2 = json['D2'];
    b1 = json['B1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['B2'] = this.b2;
    data['C2'] = this.c2;
    data['A2'] = this.a2;
    data['C1'] = this.c1;
    data['A1'] = this.a1;
    data['D1'] = this.d1;
    data['D2'] = this.d2;
    data['B1'] = this.b1;
    return data;
  }
}

class ArrangePoint{
  String point;
  ArrangePoint({this.point});
}

List<ArrangePoint> arrangePoint = [
  ArrangePoint(point: 'A1'),
  ArrangePoint(point: 'A2'),
  ArrangePoint(point: 'B1'),
  ArrangePoint(point: 'B2'),
  ArrangePoint(point: 'C1'),
  ArrangePoint(point: 'C2'),
  ArrangePoint(point: 'D1'),
  ArrangePoint(point: 'D2'),
];