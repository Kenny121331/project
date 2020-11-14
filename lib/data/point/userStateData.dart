

import 'package:cloud_firestore/cloud_firestore.dart';

class UserStateJson {
  String addressPL;
  String namePL;
  String nameUser;
  String idPL;
  String idUser;
  String namePoint;
  Timestamp rentedTime, returnTime;
  UserStateJson(
      {this.addressPL,
        this.namePL,
        this.nameUser,
        this.idPL,
        this.idUser,
        this.namePoint,
        this.rentedTime,
        this.returnTime
      });

  UserStateJson.fromJson(Map<String, dynamic> json) {
    addressPL = json['addressPL'];
    namePL = json['namePL'];
    nameUser = json['nameUser'];
    idPL = json['idPL'];
    idUser = json['idUser'];
    namePoint = json['namePoint'];
    rentedTime = json['rentedTime'];
    returnTime = json['returnTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressPL'] = this.addressPL;
    data['namePL'] = this.namePL;
    data['nameUser'] = this.nameUser;
    data['idPL'] = this.idPL;
    data['idUser'] = this.idUser;
    data['namePoint'] = this.namePoint;
    data['rentedTime'] = this.rentedTime;
    data['returnTime'] = this.returnTime;
    return data;
  }
}