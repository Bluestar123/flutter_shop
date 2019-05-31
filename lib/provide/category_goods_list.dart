import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryGooods> goodslist = [];
  //图文商品列表
  getGoodsList(List<CategoryGooods> list){
    goodslist=[];
    goodslist.addAll(list);
    notifyListeners();
  }

  getMoreList(List<CategoryGooods> list){
    goodslist.addAll(list);
    notifyListeners();
  }
}