
import 'package:cloud_firestore/cloud_firestore.dart';

class PointJson {
  String namePoint;
  String idPL, idUserState, idPoint;
  Timestamp rentedTime, returnTime;

  PointJson({
    this.namePoint,
    this.idPL,
    this.rentedTime,
    this.returnTime,
    this.idUserState,
    this.idPoint
  });

  PointJson.fromJson(Map<String, dynamic> json) {
    namePoint = json['namePoint'];
    idPL = json['idPL'];
    rentedTime = json['rentedTime'];
    returnTime = json['returnTime'];
    idUserState = json['idUserState'];
    idPoint = json['idPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['namePoint'] = this.namePoint;
    data['idPL'] = this.idPL;
    data['rentedTime'] = this.rentedTime;
    data['returnTime'] = this.returnTime;
    data['idUserState'] = this.idUserState;
    data['idPoint'] = this.idPoint;
    return data;
  }
}