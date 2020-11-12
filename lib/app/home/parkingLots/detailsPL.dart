import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Details extends StatelessWidget {
  static final ROUTER = '/Detail';
  final String documentId;
  Details({this.documentId});
  CollectionReference parkingLots = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth user = FirebaseAuth.instance;
  Widget richText(String text1, int text2, String text3) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: text1, style: TextStyle(fontSize: 21, color: Colors.black)),
              TextSpan(text: '$text2', style: TextStyle(fontSize: 21, color: Colors.black)),
              TextSpan(text: text3, style: TextStyle(fontSize: 21, color: Colors.black)),
            ]
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Parking lot'
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: parkingLots.doc(documentId).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();
                print(data['numberPhone']);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(data['namePL']),
                            text(data['address']),
                            richText('Số điện thoại: ', data['numberPhone'], null),
                            richText('Tổng số chỗ: ', data['tổng số chỗ'], null),
                            richText('Giá một giờ thuê ', data['Giá một giờ thuê'], ' nghìn'),
                            richText('Giá phạt quá hạn ', data['Giá phạt quá hạn'], ' nghìn'),

                            Padding(
                              padding: const EdgeInsets.only(top: 80),
                              child: Center(
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: (){
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Points(
                                    //           documentId: documentId,
                                    //         )
                                    //     )
                                    // );
                                  },
                                  child: Text(
                                      'Find empty point'
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return Scaffold(
                body: Center(
                  child: Text("loading", style: TextStyle(color: Colors.red, fontSize: 30),),
                ),
              );
            }
        )
    );
  }
}