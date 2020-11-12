import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/allPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/detailsPL.dart';
import 'package:flutter_app_parkinglots/app/home/userInformation/information.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/users/users.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  static final ROUTER = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Position _currentPosition;
  GeoPoint _geoPoint;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GoogleMapController mapController;
  bool _search = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  //CollectionReference userState = FirebaseFirestore.instance.collection('userState');
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  final FirebaseAuth user = FirebaseAuth.instance;
  String _name='', _numberPhone = '';
  List<Marker> allMarkers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarkers();
    getCurentLocation();
    _getInfor();
  }
  getCurentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position){
      setState(() {
        _currentPosition = position;
      });
    });
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = p[0];
  }
  _getMarkers() async {
    FirebaseFirestore.instance
        .collection('parkingLot')
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        if(doc.data()['location'] != null) {
          print(doc.data()['location']);
          GeoPoint position = doc.data()['location'];
          print(position.latitude);
          print(position.longitude);
          return allMarkers.add(Marker(
            markerId: MarkerId(doc.id),
            onTap: (){
              print('this is my marker');
              print('${doc.data()['numberPhone']}');
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Details(
                    documentId: doc.id,
                  ))
              );
            },
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
                title: doc.data()['namePL'],
                snippet: doc.data()['address']
            ),
          ));
        }
      });
    });
  }
  // _getUserState() async {
  //   try{
  //     userState
  //         .doc(user.currentUser.uid)
  //         .get()
  //         .then((value){
  //       print(value);
  //       if (value.data() == null){
  //         return showDialog<void>(
  //           context: context,
  //           barrierDismissible: false, // user must tap button!
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('Announce'),
  //               content: SingleChildScrollView(
  //                   child: Text('Sorry! You haven\'t booked.')
  //               ),
  //               actions: <Widget>[
  //                 RaisedButton(
  //                   color: Colors.green,
  //                   child: Text('ok'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       } else {
  //         print(value.data()['reserveTime']);
  //         if (value.data()['rentTime'] == null){
  //           print('wrong');
  //
  //           return Navigator.pushNamed(context, Reservation.ROUTER);
  //         } else {
  //
  //           return Navigator.pushNamed(context, UserHired.ROUTER);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  _getInfor(){
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(user.currentUser.uid != null){
          if(doc.data()['email'] == user.currentUser.email) {
            setState(() {
              _name = doc.data()['name'];
              _numberPhone = doc.data()['numberPhone'];
            });
          }
        }
      });
    });
  }
  _check(){
    parkingLot
    .get()
        .then((value){
       value.docs.forEach((element) {
         var _parkingLot = ParkingLotJson.fromJson(element.data());
         print(_parkingLot.id);
       });
    });
    // users
    //     .get()
    //     .then((value){
    //    value.docs.forEach((element) {
    //      //print(element.data());
    //      var _user = UserJson.fromJson(element.data());
    //      print(_user.name);
    //    });
    // });
  }

  Widget text(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }
  Widget textField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){},
            ),
            hintText: 'Enter your destination',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: const BorderRadius.all(
                  Radius.circular(20)
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: const BorderRadius.all(
                  Radius.circular(20)
              ),
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) => IconButton(
          icon: Icon(Icons.playlist_play, size: 40),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )),
        title: Text(
            'Find parking lot'
        ),
        actions: [
          IconButton(
            icon: Icon(_search ? Icons.close : Icons.search),
            onPressed: (){
              setState(() {
                _search = ! _search;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(21.007285, 105.843061) ,
                zoom: 16
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set.from(allMarkers),
            onMapCreated: (GoogleMapController googleMapController){
              setState(() {
                mapController = googleMapController;
              });
            },
          ),
          _search ? textField() : Container()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.blue
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Hello'),
                          text(_name),
                          text(_numberPhone)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle),
                  trailing: Icon(Icons.arrow_right),
                  title: Text('Profile', style: TextStyle(fontSize: 18),),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Information()
                        )
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  trailing: Icon(Icons.arrow_right),
                  title: text('My State'),
                  //onTap: _getUserState,
                ),
                ListTile(
                  leading: Icon(Icons.event_note),
                  trailing: Icon(Icons.arrow_right),
                  title: text('All parking lots'),
                  onTap: (){
                    Navigator.pushNamed(context, AllParkingLots.ROUTER);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event_note),
                  trailing: Icon(Icons.arrow_right),
                  title: text('Check'),
                  onTap: (){
                    _check();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 200),
                  child: GestureDetector(
                    onTap: (){
                      FirebaseAuth.instance.signOut().then((_){
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil( Login.ROUTER, (Route<dynamic> route) => false);
                      });
                    },
                    child: Text('Log out', style: TextStyle(fontSize: 18, color: Colors.grey),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'My location',
        onPressed: (){
          mapController.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
                  16
              )
          );
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}


