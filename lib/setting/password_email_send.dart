import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordEmailSend extends StatefulWidget {
  @override
  _PasswordEmailSendState createState() => _PasswordEmailSendState();
}

class _PasswordEmailSendState extends State<PasswordEmailSend> {
  String email='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/background.png'),
                fit: BoxFit.fill,
              alignment:Alignment.topCenter,
            )
        ),
        child: Stack(
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.all(0.0),
              children:<Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/2,),
//                Container(
//                  child: Center(
//                    child:Text('Send Reset Email',style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: 20.0,
//
//                    ),)
//                  ),
//                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                labelText: 'Enter your Email',
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
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if(val.isEmpty){
                                return 'Please Enter Email';
                              }
                            },
                            onSaved: (val){
                              setState(() {
                                email=val;
                              });
                            },
                          ),

                          SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                            height: 40.0,
                            minWidth: 350.0,
                            color: Color(0xff29b6f6),
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            child: Text('Send',style: TextStyle(color: Colors.white),),
                            onPressed: () async {
                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((res){
                                  _displaySnackBar(context);
                                  Navigator.of(context).pop();
                                }).catchError((error){
                                  print('errorerror $error');
                                });
                              }

                              },
                          )
                        ],
                      )
                  ),
                ),],
            ),
          ],
        ),
      ),
    );
  }
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Reset Link has been sent to your email'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
