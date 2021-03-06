import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      width:ScreenUtil().setWidth(750),
      child:Provide<CartProvide>(
        builder:(context,child,data){
          return Row(
            children: <Widget>[
              _selectAll(context),
              _allPrice(context),
              _goButton(context)
            ],
          );
        }
      )
    );
  }
  //全选
  Widget _selectAll(context){
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;
    return Container(
      child: Row(children: <Widget>[
        Checkbox(
          value: isAllCheck,
          activeColor:Colors.pink,
          onChanged:(bool val){
            Provide.value<CartProvide>(context).changeAllCheck(val);
          }
        ),
        Text('全选')
      ],),
    );
  }

  //合计
  Widget _allPrice(context){
    var allPrice = Provide.value<CartProvide>(context).allPrice;
    return Container(
      width:ScreenUtil().setWidth(430),
      child:Column(
        children:<Widget>[
          Row(
            children:<Widget>[
              Container(
                alignment:Alignment.centerRight,
                width:ScreenUtil().setWidth(280),
                child: Text(
                  '合计',
                  style:TextStyle(
                    fontSize: ScreenUtil().setSp(36)
                  )
                ),
              ),
              Container(
                alignment:Alignment.centerRight,
                width: ScreenUtil().setWidth(150),
                child:Text(
                  '￥ ${allPrice}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    color:Colors.red
                  ),
                )
              )
            ]
          ),
          Container(
            width:ScreenUtil().setWidth(430),
            alignment:Alignment.centerRight,
            child:Text(
              '满十元免配送费',
              style:TextStyle(
                color:Colors.black38,
                fontSize:ScreenUtil().setSp(22),
              )
            )
          )
        ]
      )
    );
  }

  //结算
  Widget _goButton(context){

    var allCount = Provide.value<CartProvide>(context).allGoodsCount;

    return Container(
      width:ScreenUtil().setWidth(160),
      padding:EdgeInsets.only(left:20),
      child:InkWell(
        child:Container(
          padding:EdgeInsets.all(10.0),
          alignment:Alignment.center,
          decoration:BoxDecoration(
            color:Colors.red,
            borderRadius:BorderRadius.circular(3.0)
          ),
          child:Text(
            '结算(${allCount})',
            style:TextStyle(
              color:Colors.white
            )
          )
        ),
        onTap:(){

        }
      )
    );
  }
}