import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import '../../provide/detail_info.dart';
import '../../provide/currentIndex.dart';

class DetailBottom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var goodInfo = Provide.value<DetailInfoProvide>(context).goodsInfo.data.goodInfo;
    var goodId = goodInfo.goodsId;
    var goodName = goodInfo.goodsName;
    var count = 1;
    var price = goodInfo.presentPrice;
    var image = goodInfo.image1;

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      color: Colors.white,
      child: Row(
        children: <Widget>[

          Stack(
            children: <Widget>[
                InkWell(
                  onTap: (){
                    Provide.value<CurrentIndexProvide>(context).changeIndex(2);

                    Navigator.pop(context);//关闭当前界面

                  },
                  child:Container(
                    width: ScreenUtil().setWidth(110),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.shopping_cart,
                      size:35,
                      color:Colors.red
                    ),
                  )
                ),
                Provide<CartProvide>(
                  builder: (context,child,data){
                    int goodsCount = Provide.value<CartProvide>(context).allGoodsCount;
                    return Positioned(
                      right: 10,
                      top:0,
                      child: Container(
                        padding:EdgeInsets.fromLTRB(6, 3, 6, 3),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(width: 2,color: Colors.white),
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Text('${goodsCount}',style: TextStyle(color: Colors.white),),
                      ),
                    );
                  },
                )
            ],
          ),

          
          InkWell(
            onTap:()async{
              await Provide.value<CartProvide>(context).save(goodId,goodName,count,price,image);
            },
            child:Container(
              color:Colors.teal,
              alignment: Alignment.center,
              child: Text('加入购物车',style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(30)
              ),),
              width: ScreenUtil().setWidth(320),
            )
          ),
          InkWell(
            onTap:()async{
              await Provide.value<CartProvide>(context).remove();
            },
            child:Container(
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: Text('立即购买',style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(30)
              ),),
              width: ScreenUtil().setWidth(320),
            )
          )
        ],
      ),
    );
  }
}