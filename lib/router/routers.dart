//所有路由的一个配置
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static String root = '/';//根目录
  static String detailPage = '/detail'; //商品详情页
  static void configureRoutes(Router router){//引入的fluro里面的router参数
    //404
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print('error======>ROUTE WAS NOT FOUND!!!!!!!!!');
      }
    );

    //配置路由
    router.define(detailPage,handler:detailsHandler,transitionType: TransitionType.inFromRight);
  }
}