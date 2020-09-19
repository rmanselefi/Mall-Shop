import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  String password='';
  String oldPassword='';
  String confirmPassword='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return SingleChildScrollView(
            child: Stack(
              children:<Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal:5.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Enter your old password',
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                labelStyle: TextStyle(
                                color:Colors.white
                            )),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            validator: (val) =>
                            val.isEmpty ? 'Please Enter Old Password' : null,
                            onSaved: (val){
                              print("valvalvalvalval $val");
                              setState(() {
                                oldPassword=val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Enter your new password',
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                labelStyle: TextStyle(
                                color:Colors.white
                            )),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            validator: (val) =>
                            val.isEmpty ? 'Please Enter your new Password' : null,
                            onSaved: (val){
                              print("valvalvalvalval $val");
                              setState(() {
                                password=val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm password',
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                                ),
                                labelStyle: TextStyle(
                                color:Colors.white
                            )),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            validator: (val) =>
                            val.isEmpty ? 'Please Confirm your password' : null,
                            onSaved: (val){
                              print("valvalvalvalval $val");
                              setState(() {
                                confirmPassword=val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                            height: 50.0,
                            minWidth: 350.0,
                            child: Text('Change Password',style: TextStyle(color: Colors.white),),
                            color: Color(0xff29b6f6),
                            onPressed: () async {
                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                final SharedPreferences prefs = await SharedPreferences
                                    .getInstance();
                                var oldPass = prefs.getString('password');
                                print("passwordpasswordpassword${oldPass}");
                                if (confirmPassword != password) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Please confirm your password'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                                else if (oldPassword != oldPass) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Please enter a correct old password'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                                else {
                                  var user = await FirebaseAuth.instance
                                      .currentUser();
                                  user.updatePassword(password).then((res) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                'Password is Changed successfully'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }).catchError((err) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(err.toString()),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  });
                                }
                              }
                            },
                          )
                        ],
                      )
                  ),
                ),],
            ),
          );
        });
  }
}
