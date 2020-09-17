import 'package:mallshop/models/product.dart';
import 'package:mallshop/models/shop.dart';
import 'package:mallshop/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConnectedModels extends Model{
  bool isLoading=true;
  User authenticatedUser;
  List<Product> userProducts=[];
  List<Product> specialProducts=[];
  var shopName='';
  var shopId='';
  var shopImage='';
  var shopCategory='';
  var password='';

  Future<Shop> getAuthenticatedShop() async {
    try{
      var docs = await Firestore.instance.collection('shop').getDocuments();
      if (docs.documents.isNotEmpty) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        if(pref.containsKey('user_id')) {
          final String userID = pref.getString('user_id');

          var doc = docs.documents
              .where((sh) => sh.data['user_id'] == userID)
              .toList();
          var data = doc[0].data;
          final Shop shop = Shop(
            Id: doc[0].documentID,
            shopName:data.containsKey('shop_name') ? data['shop_name'] : '',
            shopCategory: data.containsKey('category')?data['category']:'',
          );
          return shop;
        }
      }
    }
    catch(e){

    }

  }
}