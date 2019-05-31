import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailInfoProvide>(builder: (context,child,data){
      var isLeft = Provide.value<DetailInfoProvide>(context).isLeft;
      var isRight = Provide.value<DetailInfoProvide>(context).isRight;

      return Container(
        margin: EdgeInsets.only(top:15.0),
        child:Row(
          children: <Widget>[
            _myTabbarLeft(context,isLeft),
            _myTabbarRight(context,isRight)
          ],
        )
      );
    },);
  }

  //点击左侧
  Widget _myTabbarLeft(BuildContext context,bool isLeft){
    return InkWell(
      onTap: (){
        Provide.value<DetailInfoProvide>(context).changeLeftOrRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: isLeft?Colors.pink:Colors.black12)
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isLeft?Colors.pink:Colors.black
          ),
        ),
      ),
    );
  }

  //点击右侧
  Widget _myTabbarRight(BuildContext context,bool isRight){
    return InkWell(
      onTap: (){
        Provide.value<DetailInfoProvide>(context).changeLeftOrRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: isRight?Colors.pink:Colors.black12)
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isRight?Colors.pink:Colors.black
          ),
        ),
      ),
    );
  }
}