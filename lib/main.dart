import 'package:flutter/material.dart';
import 'package:mallshop/products/products.dart';
import 'package:mallshop/scoped_models/auth.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';


import 'package:mallshop/setting/ChangeBackground.dart';
import 'package:mallshop/setting/ChangePassword.dart';
import 'auth/SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final MainModel _model = new MainModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model.autoAuthenticate();
    _model.getShopBackGround(_model.shopId);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: FutureBuilder(
        future: _model.autoAuthenticate(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return CircularProgressIndicator();
          }
          print('project snapshot data is: ${projectSnap.data}');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: projectSnap.data != null ? ProductPage(_model) : SignIn(),
            routes: {
              '/home':(BuildContext context)=>ProductPage(_model),
              '/change':(BuildContext context)=>ChangePassword(),
              '/changeImage':(BuildContext context)=>ChangeBackground(_model,_model.shopId),
            },
          );
        },

      ),
    );
  }
}
