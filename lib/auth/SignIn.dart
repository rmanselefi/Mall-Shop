import 'package:flutter/material.dart';
import 'package:mallshop/models/user.dart';
import 'package:mallshop/scoped_models/auth.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:mallshop/setting/password_email_send.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>  {
  bool _saving = false;
  final _formData = User(email: '', password: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model)
        {
          return MaterialButton(
            height: 50.0,
            minWidth: 350.0,
            color: Color(0xff29b6f6),
            splashColor: Colors.teal,
            textColor: Colors.white,
            child: new Text('Login'),
            onPressed: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                setState(() {
                  _saving = true;
                });
                Map<String, dynamic> successInfo = await model.Login(_formData.email, _formData.password);
                if (successInfo['success']) {
                  Navigator.pushReplacementNamed(context, '/home');
                  setState(() {
                    _saving = false;
                  });
                } else {
                  setState(() {
                    _saving = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Invalid EMail or Password'),
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
              }
            },
          );
        }

    );
  }
  Widget _showForgotPasswordButton() {
    return new FlatButton(
      child: new Text('Forgot password?',
          style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300,color:Colors.white)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordEmailSend()),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Container(
//          constraints: BoxConstraints.expand(),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/background.png'),
              fit: BoxFit.fill,
              alignment:Alignment.topCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0.0),
                  children: <Widget>[
                    SizedBox(height: 260.0,),
                    Column(
                      children: <Widget>[
                        Container(
                         padding: const EdgeInsets.all(20.0),
                         child: new Form(
                           key: _formKey,
                           child: new Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                               new TextFormField(
                                 style: TextStyle(
                                   color: Colors.white,
                                 ),
                                 decoration: new InputDecoration(
                                     labelText: "Enter Email",
                                     fillColor: Colors.white,
                                     labelStyle: TextStyle(
                                        color:Colors.white
                                      ),
                                     border: new UnderlineInputBorder(
                                         borderSide: new BorderSide(
                                             color: Colors.red
                                         )
                                     )
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide()
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
////                                   borderRadius: BorderRadius.circular(25.0),
//                                   borderSide: BorderSide(
//                                     color: Colors.white,
//                                     width: 1.0,
//                                   ),
//                                 ),
                                 ),
                                 keyboardType: TextInputType.emailAddress,
                                 validator: (val) {
                                   if(val.isEmpty){
                                    return 'Please Enter Email';
                                   }
                                 },
                                 onSaved: (String value) {
                                   _formData.email = value;
                                 },
                               ),
                               SizedBox(height: 10.0,),
                               new TextFormField(
                                 style: TextStyle(
                                   color: Colors.white,
                                 ),
                                 decoration: new InputDecoration(
                                   labelText: "Enter Password",
                                   fillColor: Colors.white,
                                   labelStyle: TextStyle(
                                     color:Colors.white
                                   ),
                                     border: new UnderlineInputBorder(
                                         borderSide: new BorderSide(
                                             color: Colors.red
                                         )
                                     )
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.white,
//                                     width: 1.0,
//                                   ),
//                                 ),
                                 ),
                                 obscureText: true,
                                 validator: (val) {
                                   if(val.isEmpty){
                                     return 'Please Enter Password';
                                   }
                                 },
                                 onSaved: (String value) {
                                   _formData.password = value;
                                 },
                                 keyboardType: TextInputType.text,
                               ),
                               new Padding(
                                 padding: const EdgeInsets.only(top: 15.0),
                               ),
                               _buildSubmitButton(),
                               _showForgotPasswordButton()
                             ],
                           ),
                         ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
