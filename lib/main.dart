import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; //横屏竖屏
import 'package:provide/provide.dart';
import 'provide/counter.dart';
import './pages/animate_page.dart';
import 'provide/child_category.dart';
import 'provide/category_goods_list.dart';
import 'provide/detail_info.dart';
import "package:fluro/fluro.dart";
import './router/routers.dart'; //配置文件
import './router/application.dart';//实例化文件
import './provide/cart.dart';
import './provide/currentIndex.dart';

void main(){

  var counter = Counter();//引入的类
  var childCategory = ChildCategory();
  var providers = Providers();//必须引入
  var categoryGoodsList =CategoryGoodsListProvide();
  var detailInfo = DetailInfoProvide();
  var cartp = CartProvide();
  var currentIndex = CurrentIndexProvide();

  providers//放入顶层
  ..provide(Provider<Counter>.value(counter))
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsList))
  ..provide(Provider<DetailInfoProvide>.value(detailInfo))
  ..provide(Provider<CartProvide>.value(cartp))
  ..provide(Provider<CurrentIndexProvide>.value(currentIndex));

  //竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(ProviderNode(child:MyApp(),providers:providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
      //声明路由
    final router = Router();
    Routes.configureRoutes(router);//配置
    Application.router = router;  //静态化

    return Container( //使以后扩展 方便  都用Container包裹  比较灵活
      child: MaterialApp(
        title: '百姓生活+',//不显示  列斯浏览器左上角
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,//不用debug
        theme: ThemeData(//主体颜色
          primaryColor: Colors.pink
        ),
        home: AnimatePage(),//自己写的页面 新的
      ),
    );
  }
}