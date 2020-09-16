import 'package:flutter/material.dart';
import 'package:mallshop/setting/password_form.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Color(0xff2a2e42),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/background.png'),
                fit: BoxFit.fill,
              alignment:Alignment.topCenter,
            )
        ),
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 260.0,
                ),

                PasswordForm()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
