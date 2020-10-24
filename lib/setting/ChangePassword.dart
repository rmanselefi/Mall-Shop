import 'package:flutter/material.dart';
import 'package:mallshop/setting/password_form.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
//        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage('assets/background.jpg'),
                          fit: BoxFit.fill,
                        alignment:Alignment.topCenter,

                      )
                  ),
//                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60.0),
                      PasswordForm(),

                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back,color: Color(0xff29b6f6),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
