import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; //数组,字符串  转换
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier{
  String cartString = "[]";
  List<CartInfoModel> cartList = [];

  double allPrice =0;//总价
  int allGoodsCount = 0;//闪屏总数；

  bool isAllCheck = true; //是否全选

  save(goodId,goodName,count,price,images) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartString = prefs.getString('cartInfo');
    var temp = cartString==null?[]:json.decode(cartString.toString());

    List<Map> tempList = (temp as List).cast();

    bool isHave = false;

    int ival = 0;
    allGoodsCount = 0;
    //循环 看有没有
    tempList.forEach((val){
      if(val['goodId']==goodId){
        tempList[ival]['count'] = val['count']+1; //map类型
        cartList[ival].count++; //model 类型
        isHave =true;
      }

      if(val['isCheck']){
        allPrice+=(cartList[ival].price*cartList[ival].count);
        allGoodsCount+=cartList[ival].count;
      }
      ival++;
    });
    //没有就 添加
    if(!isHave){

      Map<String,dynamic> newGoods = {
        'goodId':goodId,
        'goodName':goodName,
        'count':count,
        'price':price,
        'images':images,
        'isCheck':false
      };

      tempList.add(newGoods);

      //map >>> model
      cartList.add(CartInfoModel.fromJson(newGoods));//转成model对象   不是map了
      //model >>>json
      // toJson()

      allPrice+=(count*price);
      allGoodsCount+=count;

    }

    cartString = json.encode(tempList).toString();
    // print('字符串》》》》》》》》》》》》》》》》》》》${cartString}');

    // print('数据模型》》》》》》》》》》》》》》》》》》》${cartList}');

    prefs.setString('cartInfo', cartString);

    notifyListeners();
  }


  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    notifyListeners();
  }

  getCartInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];

    if(cartString==null){
      cartList = [];
    }else {  //tempList map类型 只是用于存储 list 和字符串相互转换，  cartlist是 项目中具体操作
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      //初始化
      allPrice=0;
      allGoodsCount=0;
      isAllCheck = true;
     
      tempList.forEach((val){
        // cartList.add(CartInfoModel.fromJson(val));
        cartList.insert(0, CartInfoModel.fromJson(val));
       
        if(val['isCheck']==true){
          allPrice = allPrice + val['count']*val['price'];

          allGoodsCount += val['count'];

        }else{
          //只要有一个是false 就false
          isAllCheck = false;
        }
      });
    }



    notifyListeners();
  }

  //删除单个购物车商品
  deleteOneGoods(String goodId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex=0;
    int delIndex=0;

    tempList.forEach((val){
      if(val['goodId']==goodId){
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);

    cartString = json.encode(tempList).toString();

    prefs.setString('cartInfo',cartString);

    //操作完 重新获取
    await getCartInfo();
  }


  //每个的 复选框
  changeCheckState(CartInfoModel cartItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0;

    tempList.forEach((val){
      //model 用 点取值，MAP用  中括号取值
      if(val['goodId'] == cartItem.goodId){
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    //转化成map值
    tempList[changeIndex]= cartItem.toJson(); //是为了 把true false 传过去

    cartString = json.encode(tempList).toString();

    prefs.setString('cartInfo',cartString);

    await getCartInfo();
  }


  //点击 全选合计复选
  changeAllCheck(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();
    List<Map> newList = [];

    //数组循环过程中不能改变值，  所以创建一个新的数组
    for(var item in tempList){
      var newItem = item;//创建一个 变量 改变

      newItem['isCheck'] = isCheck;

      newList.add(newItem);
    }

    cartString = json.encode(newList).toString();

    prefs.setString('cartInfo',cartString);

    await getCartInfo();
  }


  //商品数量加减
  addOrReduceAction(var cartItem,String todo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString) as List).cast();

    int tempIndex = 0;
    int currentIndex = 0;
    tempList.forEach((val){
      if(val['goodId']==cartItem.goodId){
        currentIndex=tempIndex;
      }
      tempIndex++;
    });

    if(todo == 'add'){
     
      tempList[currentIndex]['count']++;
    }else if(todo=='reduce'){
      tempList[currentIndex]['count']--;
    }
  
    cartString = json.encode(tempList).toString();

    prefs.setString('cartInfo',cartString);

    await getCartInfo();
    
  }
}