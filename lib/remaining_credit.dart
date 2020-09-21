import 'package:flutter/material.dart';
import 'package:mallshop/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class RemainingCredit extends StatefulWidget {
  final MainModel model;
  final String id;
  RemainingCredit(this.model,this.id);

  @override
  _RemainingCreditState createState() => _RemainingCreditState();
}

class _RemainingCreditState extends State<RemainingCredit> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("credit.idcredit ${widget.id}");
    widget.model.getShopCredit(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Credit'),
      ),
      body: ScopedModelDescendant<MainModel>(
          builder:  (BuildContext context, Widget child, MainModel model)  {

            return FutureBuilder(
              future: model.getShopCredit(widget.id),
              builder: (context,snap) {
                if (!snap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  if (snap.data == null) {
                    return Center(
                      child: Text('No data to show'),
                    );
                  }
                  var credit=int.parse(snap.data.shopCredit);
                  final creditedAt = snap.data.creditedDate;
                  final date2 = DateTime.now();
                  final difference = creditedAt.difference(date2).inDays;
                  var remaining=credit-difference;
                  return Column(
                    children: <Widget>[
                      Container(
                        child: Text('Remaining time'),
                      ),
                      Container(
                        child: Center(
                          child: Text('${remaining.toString()} Days',style: TextStyle(
                            color: Colors.black45,
                            fontSize: 100.0
                          ),),
                        ),
                      ),
                    ],
                  );
                }

              }
            );
          }),
    );

  }
}
