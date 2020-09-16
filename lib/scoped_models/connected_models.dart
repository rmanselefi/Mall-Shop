
import 'package:mallshop/models/product.dart';
import 'package:mallshop/models/user.dart';
import 'package:scoped_model/scoped_model.dart';


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
}