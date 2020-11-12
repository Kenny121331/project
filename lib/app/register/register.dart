
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  static final ROUTER = '/Register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _name, _email, _licensePlace, _password, _passwordCheck, _numberPhone;
  String _errorString;
  bool _error = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth user = FirebaseAuth.instance;

  Future<void> _createUser() async{
    if (_password != _passwordCheck) {
      setState(() {
        _error = true;
      });
      _errorString = 'Password incorrect';
    } else {
      _error = false;
      try {
        print('Email: $_email  Password: $_password');
        UserCredential userCredential = await FirebaseAuth
            .instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        print(user.currentUser.uid);
        users
            .doc(user.currentUser.uid)
            .set({
          'name': _name,
          'email' : _email,
          'password' : _password,
          'numberPhone' : _numberPhone,
          'licensePlate': _licensePlace,
          'id': user.currentUser.uid,
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        Navigator.pop(context, _name);
      } on FirebaseAuthException catch (e) {
        print('Error: $e');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue[300],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue[300],
          title: Text(
            'Enter your information',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Your name'),
                  TextField(
                    onChanged: (text){
                      _name = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
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
                    child: Text('Your email'),
                  ),
                  TextField(
                    onChanged: (text){
                      _email = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
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
                    child: Text('Your password'),
                  ),
                  TextField(
                    onChanged: (text){
                      _password = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
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
                    child: Text('Enter your password again'),
                  ),
                  TextField(
                    onChanged: (text){
                      _passwordCheck = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
                        errorText: _error? _errorString : null,
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
                    child: Text('Number Phone'),
                  ),
                  TextField(
                    onChanged: (text){
                      _numberPhone = text;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 21),
                    decoration: new InputDecoration(
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
                    child: Text('Your license plate'),
                  ),
                  TextField(
                    onChanged: (text){
                      _licensePlace = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
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
                  Center(
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: _createUser,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}

