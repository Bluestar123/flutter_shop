import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../loading.dart';

class DetailTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailInfoProvide>(
      builder: (context,child,data){
        // if(Provide.value<DetailInfoProvide>(context).goodsInfo==null){
        //   return Center(
        //     child: Text('加载中...')
        //   );
        // }
        var goodInfo = Provide.value<DetailInfoProvide>(context).goodsInfo.data.goodInfo;

        if(goodInfo!=null){
          return Container(
            color:Colors.white,
            child: Column(
              children: <Widget>[
                _goodImg(goodInfo.image1),
                _goodName(goodInfo.goodsName),
                _goodNum(goodInfo.goodsSerialNumber),
                _goodPrice(goodInfo.presentPrice.toString(),goodInfo.oriPrice.toString())
              ],
            ),
          );
        }else{
          return Text('加载中...');
        }
      },
    );
  }

  //商品图片
  Widget _goodImg(url){
    return Image.network(url,
      width: ScreenUtil().setWidth(740),
    );
  }
  //商品名称
  Widget _goodName(name){
    return Container(
      width:ScreenUtil().setWidth(740),
      child: Text(
        name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),

        ),
      ),
      padding: EdgeInsets.only(left: 15.0)
    );
  }

  //商品编号
  Widget _goodNum(num){
    return Container(
      width:ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin:EdgeInsets.only(top:8.0),
      child: Text(
        '商品编号：${num}',
        style:TextStyle(color:Colors.black45 )
      ),
    );
  }

  //商品加个
  Widget _goodPrice(newP,oldP){
    return Row(
      children: <Widget>[
        Text(newP,style: TextStyle(color: Colors.blue),),
        Text(
          oldP,
          style:TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.black38
          )
        )
      ],
    );
  }
}