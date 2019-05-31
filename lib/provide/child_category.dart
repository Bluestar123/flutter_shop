import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类 高亮索引
  String categoryId = '4';//白酒类别
  String subId = '';//小类id
  int page = 1;//列表页数
  String noMoreText = '';//显示没有数据的文字

  //切换大类
  getChildCategory(List<BxMallSubDto> list,String id){
    //点击触发
    childIndex = 0;
    categoryId=id;
    page=1; //切换大类 变1
    noMoreText = '';

    BxMallSubDto all=BxMallSubDto();
    all.mallSubId='';
    all.mallCategoryId='';
    all.comments='null';
    all.mallSubName='全部';

    childCategoryList=[all];

    childCategoryList.addAll(list);
    notifyListeners();
  }


  //改编子类索引
  changeChildIndex(index,String id){
    childIndex = index;
    subId=id;
    page=1; //切换子类  改变
    noMoreText = '';
    notifyListeners();
  }

  //增加page
  addPage(){
    page++;
  }
  decarasePage(){
    page--;
  }

  //改变 nomoretext
  changeNoMore(String text){
    noMoreText = text;
  }
}