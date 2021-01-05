import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLots.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _errorEmail, _errorPassword;
  bool _emailCheck = false; bool _passwordCheck = false;
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;
  bool _hide = true;
  void _toggle(){
    setState(() {
      _hide = ! _hide;
    });
  }
  void initState() {
    setUp();
    super.initState();
  }
  setUp() {
    addParkingLots.addParkingLot();
    addParkingLots.getPoints();
    addParkingLots.getStatePL();
    addParkingLots.checkReservation();
  }
  _checkInternet() async {
    final url = 'https://www.youtube.com/';
    await http.get(url).then((value) async {
      print('internet ok');
    })
        .catchError((e) => showDialogAnnounce(
      content: 'Please check your internet!'
    ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Get.toNamed(Routers.REGISTER);
    if(result != null) {
      _scafoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$result.. Register successful!'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<void> _loginUser() async {
    try {
      print('Email: $_email Password: $_password');
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
      ).then((value){
        users
            .doc(user.currentUser.uid)
            .update({
          'password' : _password
        }).then((value) => Get.toNamed(Routers.SPLASHSCREEN));
      })
          .catchError((e){
        setState(() {
          _passwordCheck = true;
          _errorPassword = 'Wrong email or password';
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkInternet();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scafoldKey,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 350,
                child: Center(
                  child: Image(
                    image: AssetImage('assets/cars.jpg'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 320,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Email'
                    ),
                    TextField(
                      onChanged: (text){
                        _email = text;
                      },
                      style: TextStyle(fontSize: 21),
                      decoration: InputDecoration(
                          errorText: _emailCheck ? _errorEmail : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)
                              )
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                          'Password'
                      ),
                    ),
                    TextField(
                      onChanged: (text){
                        _password = text;
                      },
                      style: TextStyle(fontSize: 21),
                      obscureText: _hide,
                      decoration: InputDecoration(
                          errorText:  _passwordCheck ? _errorPassword : null,
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: Icon(_hide ? Icons.visibility_off : Icons.visibility, color: Colors.black,),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)
                              )
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: (){
                              _navigateAndDisplaySelection(context);
                            },
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: RaisedButton(
                              onPressed: () => _loginUser(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: Colors.green,
                              child: Text(
                                'Log In',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: (){
                            Get.toNamed(Routers.FORGETPASSWORD);
                          },
                          child: Center(
                            child: Text(
                              'Forgot the password?',
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
