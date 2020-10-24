import 'dart:io';

class Product{
  String Id;
  String productName;
  String productPrice;
  String cardPlace;
  String productImage;
  String productDescription;
  String backgroundImage;

  bool isNormal;
  File file;
  Product({this.isNormal,this.productPrice,this.productName,this.productImage,this.Id,this.cardPlace,this.file,this.productDescription,this.backgroundImage});

}