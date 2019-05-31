import 'package:flutter/material.dart';
// import 'package:flutter_shop/model/loading-toast.dart' as prefix0;
import '../service/service_method.dart';
import 'dart:convert'; //解析json
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:provide/provide.dart';
import '../model/categoryGoodsList.dart';
import './loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:fluttertoast/fluttertoast.dart';
import '../router/application.dart';
import './router_animation.dart';


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
   // _getCategory();//页面构建时候执行
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body:Row(
        children: <Widget>[
          LeftCategoryNav(),
          Column(
            children: <Widget>[
              RightCategoryNav(),
              GategoryGoodsList(),
              // RaisedButton.icon(
              //   icon: Icon(Icons.access_alarm),
              //   onPressed: null,
              //   label: Text('点击我'),
              //   highlightColor: Colors.red,
              //   disabledColor: Colors.brown,
              // )
            ],
          )
        ],
      )
    );
  }

  
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];
  WidgetsBinding widgetsBinding = WidgetsBinding.instance;

  var rightCurrent=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1.0,color: Colors.black12))
      ),
      child:ListView.builder(
        itemCount: list.length,
        itemBuilder: (content , index){
          return _leftInkWell(index);
        },
      )
    );
  }

  //每一个的样式
  Widget _leftInkWell(int index){
    // bool isClick = false;
    // isClick=(index==rightCurrent)?true:false;
    return InkWell(
      onTap: (){
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        setState(() {
         rightCurrent=index; 
        });
        //执行第一次   必须用keyvalue形式
        _getGoodsList(categoryId:categoryId);
        // 泛型<class名>   点击调用方法
        Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);

      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0,top: 20.0),
        decoration: BoxDecoration(
          color: rightCurrent==index?Color.fromRGBO(236,236, 236, 1.0):Colors.white,
          border: Border(bottom: index!=list.length-1?BorderSide(width: 1,color: Colors.black12):BorderSide.none)
        ),
        child:Text(list[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(28)))
      ),
    );
  }


  void _getCategory() async{
    await request('getCategory').then((res){

      var data =json.decode(res.toString());
      // data['data'][0]['bxMallSubDto'].insert(0,
      //   {'mallSubId': '2c9f6c94621970a801626a35cb4d0175', 'mallCategoryId': '4', 'mallSubName': '66666666', 'comments': 'null'}
      // );
      // CategoryBigListModel list =CategoryBigListModel.fromJson(data['data']);
      CategoryModel category =CategoryModel.fromJson(data); //解析调用，使用类利于维护

      setState(() {
        list =  category.data;
      });

      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto,list[0].mallCategoryId);

     // list.data.forEach((item)=>print(item.mallCategoryName));
    });
  }
  ////////loading加载/////////
  void _loading(){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Loading();
      });
  }
  //图片列表
  void _getGoodsList({String categoryId}) async{
    var data = {
      'categoryId':categoryId!=null?categoryId:'4',
      'categorySubId':'',
      'page':1
    };
    //部件 都实现了，在执行
    widgetsBinding.addPostFrameCallback((_){
      _loading();
    });

    await request('getMallGoods',formData: data).then((res){
      Navigator.of(context).pop();
      var data = json.decode(res.toString());

      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      
      //包括 code 和msg  ，用数组
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}


class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  //List list = ['名酒','宝丰','北京二锅头','舍得','五粮液','茅台','散白','牛栏山'];

  // var rightTopCurrent = 0;

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return Container(
            //横向listview 需要设置宽高，纵向设置宽度就可以
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),//750-180
            decoration: BoxDecoration(
              color: Colors.white,
              border:Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black12
                )
              )
            ),
            child: //Provide<>(
             // builder: (context,child,){
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: childCategory.childCategoryList.length,
                  itemBuilder: (context,index){
                    return _rightInkWell(childCategory.childCategoryList[index],index);
                  },
                //)
              //},
            ),
          );
      },
    );
  }

  //小布局
  Widget _rightInkWell(BxMallSubDto item,int index){
    bool isClick = false;
    isClick=(index==Provide.value<ChildCategory>(context).childIndex)?true:false;

    return InkWell(
      onTap: (){
        setState(() {
        //  rightTopCurrent=index; 
          Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);

          _getGoodsList(item.mallSubId);
          
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
        child: Text(item.mallSubName,style:TextStyle(
          fontSize:ScreenUtil().setSp(28),
          color:isClick?Theme.of(context).primaryColor:Colors.black
        )),
      ),
    );
  }

  void _getGoodsList(String categorySubId) {
    var data = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };


    request('getMallGoods',formData: data).then((res){

      var data = json.decode(res.toString());

      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data==null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        //包括 code 和msg  ，用数组
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
      
    });
  }
}

//商品列表   上拉加载
class GategoryGoodsList extends StatefulWidget {

  _GategoryGoodsListState createState() => _GategoryGoodsListState();
}

class _GategoryGoodsListState extends State<GategoryGoodsList> {
  var scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  GlobalKey<RefreshFooterState> _footer = new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(

      builder: (context,child,data){
        try {
          if(Provide.value<ChildCategory>(context).page==1){
            // 列表位置 放在最上面
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          //第一次进入页面
          print('第一次进入页面 初始化${e}');
        }
        if(data.goodslist.length>0){
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child:EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footer,
                  bgColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  moreInfoColor: Theme.of(context).primaryColor,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: '加载中',
                  loadReadyText: '上拉加载',
                ),
                child: ListView.builder(
                  controller:scrollController,
                  itemCount: data.goodslist.length,
                  itemBuilder: (context,index){
                    return _listWidget(data.goodslist,index);
                  },
                ),
                loadMore: () async{
                  _getMoreList();
                },
              )
            )
          );
        }else{
          return Text('暂无数据');
        }
        

      },
    );
  }


  Widget _goodsImage(List list,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child:Image.network(list[index].image)
    );
  }

  Widget _goodsName(List list,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style:TextStyle(
          fontSize: ScreenUtil().setSp(28)
        )
      ),
    );
  }

  Widget _goodsPrice(List list,index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${list[index].presentPrice}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(30)
            ),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough
            ),
          ),
        ],
      ),
    );
  }

  Widget _listWidget(List list,int index){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(
          context, 
          '/detail?id=${list[index].goodsId}'
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom:index==list.length-1?BorderSide.none:BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(list,index),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _goodsName(list,index),
                _goodsPrice(list,index)
              ],
            )
          ],
        ),
      ),
    );
  }

  void _getMoreList() {
     Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page
    };


    request('getMallGoods',formData: data).then((res){

      var data = json.decode(res.toString());

      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data==null){
        Fluttertoast.showToast(
          msg: '没有更多数据',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Provide.value<ChildCategory>(context).changeNoMore('没有更多数据');
        Provide.value<ChildCategory>(context).decarasePage();

      }else{
        //包括 code 和msg  ，用数组
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data);
      }
      
    }).catchError((err){
      Provide.value<ChildCategory>(context).decarasePage();
    });
  }
}
