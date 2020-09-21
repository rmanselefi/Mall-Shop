import 'dart:async';
import 'dart:io';
import 'package:mallshop/models/shop.dart';
import 'package:path/path.dart';
import 'package:mallshop/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'connected_models.dart';

class ProductModel extends ConnectedModels {
  bool isFinished = false;
  StorageUploadTask uploadTask;



  Future<List<Product>> fetchProducts() async {
    userProducts.clear();
    specialProducts.clear();
    isLoading = true;
    try {

      Shop shop=await getAuthenticatedShop();

      if(shop!=null) {
        shopName = shop.shopName;
        shopCategory = shop.shopCategory;
        shopId = shop.Id;
      }
        var products =
            await Firestore.instance.collection('product').getDocuments();

        var product = products.documents
            .where((sh) => sh.data['shop']['id'] == shopId)
            .toList();

        for (var i = 0; i < product.length; i++) {
          var data = product[i].data;
          final Product prod = Product(
              Id: product[i].documentID,
              cardPlace:
                  data.containsKey('card_place') ? data['card_place'] : '',
              productName:
                  data.containsKey('product_name') ? data['product_name'] : '',
              productPrice: data.containsKey('product_price')
                  ? data['product_price']
                  : '',
              productDescription: data.containsKey('product_description')
                  ? data['product_description']
                  : '',
              productImage: data.containsKey('image') ? data['image'] : '',
            isNormal:  data.containsKey('isNormal') ? data['isNormal'] : '',
            contact: data.containsKey('contact')?data['contact']:''
          );
          var isNormal=data.containsKey('isNormal') ? data['isNormal'] : '';
          if(isNormal){
            userProducts.add(prod);
          }
          else{
            specialProducts.add(prod);
          }

        }
        isLoading = false;
        notifyListeners();



      return userProducts;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print("errorerrorerrorerrorerrorerror $error");
    }
  }

  Future<String> uploadImage(Product prod, {String path}) async {
    String fileName = basename(prod.file.path);
    final StorageReference storageReference =
        FirebaseStorage().ref().child("${prod.productName}_images/$fileName");

     uploadTask = storageReference.putFile(prod.file);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
    uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });
    notifyListeners();

// Cancel your subscription when done.
    var up = await uploadTask.onComplete;
    var imageUrl = await up.ref.getDownloadURL();
    streamSubscription.cancel();
    return imageUrl;
  }

  Future updateProduct(Product prod) async {
    if (prod.file != null) {
      await uploadImage(prod).then((res) {
        print('imageuriimageuriimageuri$res');
        if (res != null) {
          prod.productImage = res;
        }
      });
      try {
      await Firestore.instance.collection('product').document(prod.Id).updateData({
        'product_name': prod.productName,
        'product_price': prod.productPrice,
        'product_description':prod.productDescription,
        'image': prod.productImage,
        'contact':prod.contact,
        'updated_at': new DateTime.now()
      });
      notifyListeners();
      return true;
      }
      catch (e) {
        notifyListeners();
        return e.toString();
      }
    } else {
      try {
        await Firestore.instance.collection('product')
            .document(prod.Id)
            .updateData({
          'product_name': prod.productName,
          'product_price': prod.productPrice,
          'product_description': prod.productDescription,
          'contact': prod.contact,
          'updated_at': new DateTime.now()
        });
        notifyListeners();
        return true;
      }
      catch (e) {
        notifyListeners();
        return e.toString();
      }
    }

  }
  Future updateShopDetailInfo(Shop shop) async {
    Shop shopp=await getAuthenticatedShop();
    try {
        await Firestore.instance.collection('shop')
            .document(shopp.Id)
            .updateData({
          'phone': shop.shopPhone,
          'shop_website': shop.shopWebsite,
          'shop_telegram': shop.shopTelegram,
          'description': shop.shopDescription,
          'updated_at': new DateTime.now()
        }).whenComplete((getAuthenticatedShop));
        notifyListeners();
        return true;
      }
      catch (e) {
      print("updateupdate ${e.toString()}");
        notifyListeners();
        return e.toString();
      }

  }


  Future<Null> deleteProduct(Product prod) async {
    Firestore.instance.collection('product').document(prod.Id).updateData({
      'product_name': '',
      'product_price': '',
      'product_description':'',
      'contact':'',
      'image': '',
      'updated_at': new DateTime.now()
    }).whenComplete((fetchProducts));
    notifyListeners();
  }
  Future<String> getShopBackGround(String id) async {
    try {
      var docs = await Firestore.instance.collection('shop').getDocuments();
      if (docs.documents.isNotEmpty) {
        var doc = docs.documents.where((d) => d.documentID == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data;
          shopImage =
              docdata.containsKey('back_image') ? docdata['back_image'] : '';
        }
      }
      return shopImage;
    } catch (err) {
      print("errorerrorerrorerrorerrorerror $err");
      return err;
    }
  }

  Future<Shop> getShopCredit(String id) async {
    try {
      var docs = await Firestore.instance.collection('shop').getDocuments();
      if (docs.documents.isNotEmpty) {
        var doc = docs.documents.where((d) => d.documentID == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data;
          shopCr=Shop(
            creditedDate: docdata.containsKey('credited_at') ? docdata['credited_at'].toDate() : null,
            shopCredit: docdata.containsKey('remaining_time') ? docdata['remaining_time'] : ''
          );
          shopCredit =
          docdata.containsKey('remaining_time') ? docdata['remaining_time'] : '';
          var credit=int.parse(shopCredit);
          final creditedAt = docdata.containsKey('credited_at') ? docdata['credited_at'].toDate() : null;
          final date2 = DateTime.now();
          final difference = creditedAt.difference(date2).inDays;
          remaining=credit-difference;
          notifyListeners();
        }
      }
      return shopCr;
    } catch (err) {
      print("errorcredit $err");
      return err;
    }
  }
  Future<int> getRemaining(String id) async {
    try {
      var docs = await Firestore.instance.collection('shop').getDocuments();
      if (docs.documents.isNotEmpty) {
        var doc = docs.documents.where((d) => d.documentID == id).toList();
        if (doc.isNotEmpty) {
          var docdata = doc[0].data;
          shopCredit =
          docdata.containsKey('remaining_time') ? docdata['remaining_time'] : '';
          var credit=int.parse(shopCredit);
          final creditedAt = docdata.containsKey('credited_at') ? docdata['credited_at'].toDate() : null;
          final date2 = DateTime.now();
          final difference = creditedAt.difference(date2).inDays;
          remaining=credit-difference;
          notifyListeners();
        }
      }
      return remaining;
    } catch (err) {
      print("errorremaining $err");
      return err;
    }

  }

  Future<String> uploadBackImage(File back, {String path}) async {
    // final mimetypeData = lookupMimeType(image.path).split('/');
    String fileName = basename(back.path);
    final StorageReference storageReference =
        FirebaseStorage().ref().child("background_images/$fileName");

     uploadTask = storageReference.putFile(back);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });

// Cancel your subscription when done.
    notifyListeners();
    var up = await uploadTask.onComplete;
    var imageUrl = await up.ref.getDownloadURL();
    streamSubscription.cancel();
    return imageUrl;
  }

  Future<Null> updateShopBack(String id, File file) async {
    var backImage = '';
    try {
      if (file != null) {
        await uploadBackImage(file).then((res) {
          print('imageuriimageuriimageuri$res');
          if (res != null) {
            backImage = res;
          }
        });
        Firestore.instance.collection('shop').document(id).updateData({
          'back_image': backImage,
          'updated_at': new DateTime.now()
        }).whenComplete((fetchProducts));
      }
    } catch (err) {
      print("errorerrorerrorerrorerrorerror $err");
    }
  }
}
