import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mallshop/contact_us.dart';
import 'package:mallshop/setting/ChangeBackground.dart';
import 'package:mallshop/auth/SignIn.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawerCustom extends StatefulWidget {
  final MainModel model;
  DrawerCustom(this.model);
  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  _launchURL() async {
    const url = 'https://t.me/No_one47';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.model.shopName),
            backgroundColor:  Color(0xff29b6f6).withOpacity(0.9),
          ),
          Container(
            height: 10.0,
            color: Color(0xff29b6f6).withOpacity(0.9),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0xff2a2e42),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.inbox,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Contact Us',style: TextStyle(
                    color: Colors.white
                  ),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUs()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Rate Us',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
//                Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(builder: (context) => PhoneAuth()),
//                );
                  },
                ),ListTile(
                  leading: Icon(Icons.share,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Share App',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: Icon(Icons.send,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Quick Support',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
                    _launchURL();
                  },
                ),ListTile(
                  leading: Icon(Icons.update,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Update',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
//                Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(builder: (context) => PhoneAuth()),
//                );
                  },
                ),

                Divider(color: Color(0xff29b6f6).withOpacity(0.9),),
                ListTile(
                  leading: Icon(Icons.person,color:  Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Change Password',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
                    Navigator.pushNamed(context, '/change');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image,color: Color(0xff29b6f6).withOpacity(0.9)),
                  title: Text('Change Background Image',style: TextStyle(
                      color: Colors.white
                  )),
                  onTap: () {
//                  Navigator.pushNamed(context, '/changeImage');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeBackground(
                              widget.model, widget.model.shopId)),
                    );
                  },
                ),
                Divider(color: Color(0xff29b6f6).withOpacity(0.9),),
                ScopedModelDescendant(
                  builder: (BuildContext context, Widget child, MainModel model) {
                    return ListTile(
                      leading: Icon(Icons.exit_to_app,color:  Color(0xff29b6f6).withOpacity(0.9),),
                      title: Text('Logout',style: TextStyle(
                          color: Colors.white
                      )),
                      onTap: () {
                        model.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
