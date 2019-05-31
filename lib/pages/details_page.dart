import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';
import './loading.dart';
import './details_child/details_top.dart';
import './details_child/detail_explain.dart';
import './details_child/detail_tabbar.dart';
import './details_child/detail_html.dart';
import './details_child/detail_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;// 路由传过来一个变量id  接收
  WidgetsBinding widgetsBinding = WidgetsBinding.instance;
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
   
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context); //返回上一页面
            },
          ),
          title: Text('商品详情'),
          
        ),
        body: FutureBuilder(//动态渲染数据
          future: _getBackInfo(context),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Stack(
                children: <Widget>[
                  Container(
                    child:ListView(
                      children: <Widget>[
                        DetailTop(),
                        DetailExplain(),
                        DetailTabbar(),
                        DetailHtml()
                      ],
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    left:0,
                    child: DetailBottom(),
                  )
                ],
              );
            }else {
              return Loading();
            }
          },
        ),
      ),
    );
  }

  // void _loading(context){
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return new LoadingDialog();
  //     });
  // }

  Future _getBackInfo(BuildContext context) async{
    // widgetsBinding.addPostFrameCallback((_){
    //    print(1111111111111);
    //   _loading(context);
    // });
   
    await Provide.value<DetailInfoProvide>(context).getGoodsInfo(goodsId,context);
    // Navigator.of(context).pop();
    return '完成加载';
  }

}