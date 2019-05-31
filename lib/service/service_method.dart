import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';//异步的包
import 'dart:io';
import '../config/service_url.dart';
import '../pages/loading.dart';


//参数上加 {} 就是可选参数
Future request(url,{formData}) async{
  
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =ContentType.parse('application/x-www-form-urlencoded'); //来自于io库
    if(formData!=null){
      response =await dio.post(servicePath[url],data:formData);
    }else{
      response =await dio.post(servicePath[url]);
    }
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }

  } catch (e) {
    return print('ERROR------------${e}');
  }
}




//获取首页主体内容

Future getHomePageContent() async{
  print('开始获取首页数据...........');
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =ContentType.parse('application/x-www-form-urlencoded'); //来自于io库
    //传参数
    var formData = {
      'lon':'115.02932',
      'lat':'35.76189'
    };
    
    response =await dio.post(servicePath['homePageContent'],data:formData);
    if(response.statusCode==200){
      
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }

  } catch (e) {
    return print('ERROR------------${e}');
  }
}

//获取首页火爆专区商品

Future getHomePageBelowConten() async{
  print('开始获取火爆专区数据...........');
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =ContentType.parse('application/x-www-form-urlencoded'); //来自于io库
    //传参数
    int page=1;
    
    response =await dio.post(servicePath['homePageBelowConten'],data:page);
    if(response.statusCode==200){
      
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }

  } catch (e) {
    return print('ERROR------------${e}');
  }
}