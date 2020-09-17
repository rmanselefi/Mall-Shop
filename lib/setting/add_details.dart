import 'package:flutter/material.dart';
import 'package:mallshop/models/shop.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class AddDetail extends StatefulWidget {
  @override
  _AddDetailState createState() => _AddDetailState();
}

class _AddDetailState extends State<AddDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Shop _formData= Shop(
    shopPhone: '',
    shopDescription: '',
    shopTelegram: '',
    shopWebsite: ''
  );
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
            child: new Text('Save'),
            onPressed: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                var result = await model.updateShopDetailInfo(_formData);
                if (result is String) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Could not save your data'),
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
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Your data is succesfully saved'),
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
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                Text(
                'Update your settings',
                style: TextStyle(fontSize: 18.0),
              ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (val) =>
                  val.isEmpty ? 'Please Enter a name' : null,
                  onSaved: (val) {
                    setState(() {
                      _formData.shopPhone = val;
                    });
                  },
                ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Website'),
                    validator: (val) =>
                    val.isEmpty ? 'Please Enter a website url' : null,
                    onSaved: (val) {
                      setState(() {
                        _formData.shopPhone = val;
                      });
                    },
                  ),
                SizedBox(
                  height: 20.0,
                ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Telegram Link'),
                    validator: (val) =>
                    val.isEmpty ? 'Please Enter Telegram Link' : null,
                    onSaved: (val) {
                      setState(() {
                        _formData.shopPhone = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (val) {
                    setState(() {
                      _formData.shopDescription = val;
                    });
                  },
                ),
                  _buildSubmitButton()
                ]
              ),
            ),
          )
      );
    });
  }
}
