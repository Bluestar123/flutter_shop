import "package:flutter/material.dart";
import "package:fluro/fluro.dart";
import "../pages/details_page.dart";  //有路由就会有页面  一个页面是一个类
import '../pages/router_animation.dart';

// 对应什么的handler  命名
Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){  //map  固定写法
    String goodsId = params['id'].first;
    // String name = params['name'].first;
    print('index>details goodsId is ${goodsId}');
    // print('index>details goodsId is ${name}');
    return DetailsPage(goodsId);  //return 一个类
  }
);
