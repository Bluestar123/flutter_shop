import 'package:flutter/material.dart';
import '../model/detail.dart';
import '../service/service_method.dart';
import 'dart:convert';//解析json
import '../pages/loading.dart';

class DetailInfoProvide with ChangeNotifier {
  DetailModel goodsInfo = null;


  bool isLeft = true;
  bool isRight = false;
  //tabbar 的切换
  changeLeftOrRight(String chageState){
    if(chageState=='left'){
      isLeft = true;
      isRight = false;
    }else{
      isRight = true;
      isLeft = false;
    }

    notifyListeners();
  }

  //从后台获取数据
  getGoodsInfo(String id,context) async{
    var formData = {
      'goodId':id
    };
    
    await request('getGoodDetailById',formData:formData).then((val){
      var responseData = json.decode(val.toString());//转成map
      // print(responseData);

      goodsInfo = DetailModel.fromJson(responseData); //转为对象
      notifyListeners();
    });
  }
}