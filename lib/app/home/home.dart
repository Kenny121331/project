import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/bill/bill.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/allPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/detailsPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/fiveNearestPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/MyRentStates.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/stateReservation.dart';
import 'package:flutter_app_parkinglots/app/home/userInformation/information.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLotsJson/parkingLotJson.dart';
import 'package:flutter_app_parkinglots/data/destination/destinationData.dart';
import 'package:flutter_app_parkinglots/data/users/users.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  static final ROUTER = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor parkingLotFull, parkingLotNotFull, myLocation;
  Position _currentPosition;
  var _destination = <String>[];
  String _chooseDestination;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Completer<GoogleMapController> mapController = Completer();
  bool _search = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference userState = FirebaseFirestore.instance.collection('userState');
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference bill = FirebaseFirestore.instance.collection('bill');
  final FirebaseAuth user = FirebaseAuth.instance;
  String _name='', _numberPhone = '';
  List<Marker> allMarkers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMarkers();
    _getInfor();
    _getDestination();
    _announceCancelPoint();
  }

  _getCurentLocation() async {
    if (_currentPosition == null){
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position){
        setState(() {
          _currentPosition = position;
        });
      });
    } else {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
    }
  }
  _getMarkers() async {
    parkingLot
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        var _parkingLot = ParkingLotJson.fromJson(doc.data());
        if(_parkingLot.geoPoint != null) {
          print(_parkingLot.geoPoint);
          setState(() {
            allMarkers.add(Marker(
              markerId: MarkerId(doc.id),
              icon: _parkingLot.statePL ? parkingLotNotFull : parkingLotFull,
              onTap: (){
                print('this is my marker');
                print(_parkingLot.numberPhone.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Details(
                      documentId: doc.id,
                    ))
                );
              },
              position: LatLng(_parkingLot.geoPoint.latitude, _parkingLot.geoPoint.longitude),
              infoWindow: InfoWindow(
                  title: _parkingLot.namePL,
                  snippet: _parkingLot.address
              ),
            ));
          });
        }
      });
    });
  }
  createMarkerFull(context) {
    if (parkingLotFull == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/full.png')
          .then((icon) {
        setState(() {
          parkingLotFull = icon;
        });
      });
    }
  }
  createMarkerNotFull(context){
    if (parkingLotNotFull == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/ok.png')
          .then((icon) {
        setState(() {
          parkingLotNotFull = icon;
        });
      });
    }
  }
  createMarkerMyLocation(context){
    if (myLocation == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/my_location.png')
          .then((icon) {
        setState(() {
          myLocation = icon;
        });
      });
    }
  }
  _getInfor(){
    users
    .doc(user.currentUser.uid)
    .get()
    .then((value){
      var _user = UserJson.fromJson(value.data());
      setState(() {
        _name = _user.name;
        _numberPhone = _user.numberPhone;
      });
    });
  }
  _getDestination() async {
    await parkingLot
    .get()
    .then((value){
      value.docs.forEach((element) {
        _destination.add(element.data()['namePL']);
      });
    }).then((value){
      destination.forEach((element) {
        _destination.add(element.name);
      });
    });
  }
  _query() async {
    if (_chooseDestination == null) {
      _showError('please enter your destination');
    } else {
      await parkingLot
      .where('namePL', isEqualTo: _chooseDestination)
          .get()
          .then((value){
         value.docs.forEach((element) {
           if (_chooseDestination.compareTo(element.data()['namePL']) == 0){
             print(element.data()['id']);
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Details(
                 documentId: element.data()['id']
               ))
             );
           }
         });
      });
      await destination.forEach((element2) {
        if (_chooseDestination.compareTo(element2.name) == 0){
          _chooseFivePL(element2.location);
        }
      });
      //_showError('Don\'t find your destination');
    }
  }
  _chooseFivePL(GeoPoint point2) async {
    await parkingLot
    .get()
        .then((value) {
          value.docs.forEach((element) {
            _countDistant(element.data()['location'], point2, element.data()['id']);
          });
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FiveNearstPL())
    );
  }
  Future<void> _countDistant(GeoPoint point1, GeoPoint point2, String id) async {
    final double distance = await Geolocator().distanceBetween(
        point1.latitude,
        point1.longitude,
        point2.latitude,
        point2.longitude
    );
    parkingLot.doc(id)
    .update({
      'distance' : double.parse((distance/1000).toStringAsFixed(1))
    });
    print(distance);
  }
  Future<void> _showError(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.green,
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _goReservation(){
    userState
    .where('stateRent', isEqualTo: false)
    .where('idUser', isEqualTo: user.currentUser.uid)
    .get()
        .then((value){
          if (value.docs.length > 0) {
            Navigator.pushNamed(context, MyReservations.ROUTER);
          } else {
            _showError('You do not have any reservations');
          }
    });
  }
  _goRent(){
    userState
        .where('stateRent', isEqualTo: true)
    .where('idUser', isEqualTo: user.currentUser.uid)
        .get()
        .then((value){
      if (value.docs.length > 0) {
        Navigator.pushNamed(context, MyRentStates.ROUTER);
      } else {
        _showError('You do not have any state rents');
      }
    });
  }
  _goToBill(){
    bill
    .where('idUser', isEqualTo: user.currentUser.uid)
        //.orderBy('rentTime', descending: false)
        .get()
        .then((value) {
       if (value.docs.length > 0){
         Navigator.pushNamed(context, MyBills.ROUTER);
       } else {
         _showError('You do not have any bills');
       }
    });
  }
  _announceCancelPoint(){
    userState
    .where('idUser', isEqualTo: user.currentUser.uid)
    .where('notUsed', isEqualTo: true)
    .get()
        .then((value){
          if (value.docs.length > 0){
            _showError('Your state was deleted');
          }
    });
  }



  Widget text(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }
  Widget autoCompleteTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AutoCompleteTextField(
        //controller: _suggestionTextFieldController,
        clearOnSubmit: false,
        suggestions: _destination,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await _query();
                //_chooseDestination = null;
              },
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
        itemFilter: (item, query){
          return item.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b){
          return a.compare(b);
        },
        itemSubmitted: (item){
          if (item != null){
            _chooseDestination = item;
          }
        },
        itemBuilder: (context , item) {
          //print(item);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                item,
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    createMarkerFull(context);
    createMarkerNotFull(context);
    createMarkerMyLocation(context);
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
                target: LatLng(21.007285, 105.843061),
                zoom: 16
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set.from(allMarkers),
            onMapCreated: (GoogleMapController googleMapController){
             mapController.complete(googleMapController);
            },
          ),
          _search ? autoCompleteTextField() : Container()
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
                  title: text('My reservation states'),
                  onTap: (){
                    _goReservation();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.directions_car),
                  trailing: Icon(Icons.arrow_right),
                  title: text('My rental state'),
                  onTap: (){
                    _goRent();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event_note),
                  trailing: Icon(Icons.arrow_right),
                  title: text('My bill'),
                  onTap: (){
                    _goToBill();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_parking),
                  trailing: Icon(Icons.arrow_right),
                  title: text('All parking lots'),
                  onTap: (){
                    Navigator.pushNamed(context, AllParkingLots.ROUTER);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 100, bottom: 10),
                  child: GestureDetector(
                    onTap: (){
                      FirebaseAuth.instance.signOut().then((_){
                        Navigator.of(context)
                            .pushReplacementNamed( Login.ROUTER);
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
        onPressed: () async {
          final GoogleMapController controller = await mapController.future;
          await _getCurentLocation();
          if (_currentPosition != null){
            setState(() {
              allMarkers.add(Marker(
                markerId: MarkerId('MyLocation'),
                icon: myLocation,
                position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                infoWindow: InfoWindow(
                    title: 'My location'
                ),
              ));
            });
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
                  16
              ),
            );
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
  @override
  void dispose() {
    mapController.future.then((value) => value.dispose());
    super.dispose();
  }
}


