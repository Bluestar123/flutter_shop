import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';//shiyong  json
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import './loading.dart';
import '../router/application.dart';
import '../model/loading.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

//保存页面位置
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  int page =1;
  List<Map> hotGoodsList =[];

  GlobalKey<RefreshFooterState> _footer = new GlobalKey<RefreshFooterState>();

  //保存页面位置必须重写
  @override
  bool get wantKeepAlive => true;
  String homePageContent = '正在获取数据.....';
  @override
  void initState() {
    super.initState();
    // _getHotGoods();
    print('11111111');
  }

  @override
  Widget build(BuildContext context) {
    
    var formData = {
      'lon':'115.02932',
      'lat':'35.76189'
    };
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text('百姓生活+'),
           centerTitle: true,
         ),
         body: FutureBuilder(//解决异步请求 + 渲染 、、不用setState渲染就能实现
            future: request('homePageContent',formData:formData),//接受异步方法
            builder: (context,snapshot){ //得到请求的返回值
              if(snapshot.hasData){
                
                //是否有值
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();//返回的都是map形式  解析
                // List swiper = data['data']['slides'];

                List navigatorList = (data['data']['category'] as List).cast();
                String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                String leaderImage = data['data']['shopInfo']['leaderImage'];
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                //强制转换
                // List<Map> recommendList = (data['data']['recommend'] as List).cast();
                var recommendList = data['data']['recommend'];

                String floor1Title1 = data['data']['floor1Pic']['PICTURE_ADDRESS'];
                List<Map> floor1 = (data['data']['floor1'] as List).cast();

                String floor1Title2 = data['data']['floor2Pic']['PICTURE_ADDRESS'];
                List<Map> floor2 = (data['data']['floor2'] as List).cast();

                String floor1Title3 = data['data']['floor3Pic']['PICTURE_ADDRESS'];
                List<Map> floor3 = (data['data']['floor3'] as List).cast();
                
                return EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key:_footer,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: false,
                    noMoreText: '',
                    moreInfo: '加载中...',
                    loadReadyText: '上拉加载',
                    loadingText: 'loading',
                  ),
                  child:ListView(
                    children: <Widget>[
                      SwiperDiy(swiperDateList: swiper,),
                      TopNavigator(navigatorList: navigatorList),
                      AdBanner(adPicture:adPicture),
                      LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone,),
                      Recommend(recommendList: recommendList,),
                      FloorTitle(picture_address: floor1Title1,),
                      FloorContent(floorGoodsList: floor1,),
                      FloorTitle(picture_address: floor1Title2,),
                      FloorContent(floorGoodsList: floor2,),
                      FloorTitle(picture_address: floor1Title3,),
                      FloorContent(floorGoodsList: floor3,),
                      _hotGoods()
                      // Image.network('http://hbimg.b0.upaiyun.com/90b53bebb98af92eb167c6fa2ff52aec0e6e2ff51eb05-uzMPxE_fw658')
                    ],
                  ),
                  loadMore: () async{
                    print('加载1111111111');
                    var formData = {'page':page};
                    await request('homePageBelowConten',formData:formData).then((res){
                      var data = json.decode(res.toString());//返回的是个字符串
                      List<Map> newGoodsList = (data['data'] as List ).cast();

                      if(newGoodsList.length>0){
                        setState(() {
                          hotGoodsList.addAll(newGoodsList);
                          page++;
                        });
                      }else{
                        page--;
                      }

                    });
                  },
                );
              }else{
                //没有数据
                return new Loading();
                
              }
            },//异步进行 怎么操作
         ),
       ),
    );
  }

  //标题
  Widget hotTitle =Container(
    padding: EdgeInsets.all(5.0),
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color:Colors.transparent,
    child: Text('火爆专区'),
  );

  //火爆专区商品列表
  Widget _wrapList(){
    if(hotGoodsList.length!=0){
      //流式布局 把 map数组换成 widget数据
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/detail?id=${val["goodsId"]}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width:ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26)
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val["mallPrice"]}'),
                    Text(
                      '￥${val["price"]}',
                      style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough)
                    )
                  ]
                )
              ],
            ),
          ),
        );
      }).toList();

      //流布局 两列
      return Wrap(
        spacing: 2.0,//间距
        runSpacing: 5.0,
        children: listWidget,
      );
    }else{
      return Text('没有数据');
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}

//轮播图 组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  // SwiperDiy({Key key,this.swiperDateList}):super(key:key);
  //自调用的构造函数
  SwiperDiy({this.swiperDateList});  //传的参数是一个map   实例化的时候会执行

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (context,index){
          return InkWell(
            child: Image.network("${swiperDateList[index]['image']}",fit: BoxFit.cover),//变量 images地址
            onTap: (){
              Application.router.navigateTo(context, '/detail?id=${swiperDateList[index]["goodsId"]}');
            },
          );
        },
        itemCount: swiperDateList.length,//数量就是 list长度
        pagination: SwiperPagination(),//指示点
        autoplay: true,
      ),
    );
  }
}

//grid导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);//实例化传的参数

  //九宫格，点击跳转 用 InkWell组件///      item代表每一项
  Widget _gridViewItemUI(BuildContext context,item){
  //grid 嵌套点击跳转 必备 自动给好样式
    return InkWell(
      onTap: (){
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length>0){
      this.navigatorList.removeRange(10,this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context,item);
        }).toList(),
      ),
    );
  }
}


//广告
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Image.network(adPicture)
      ),
      onTap: (){
        print('点击了广告');
      },
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage,this.leaderPhone}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherURL,
        child:Image.network(leaderImage) ,
      ),
    );
  }
 //点击拨打电话  异步操作
  void _launcherURL() async{
    String url = 'tel:' + leaderPhone;
    // const url = 'https://flutter.io';
    // const url = 'sms:5550101234';
    if(await canLaunch(url)){
      //可以判断 url是否可用，如果可用
      await launch(url);
    }else{
      throw 'url访问异常';
    }

  }
}


//商品推荐类
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  //每一个小组件都写一个内部的方法，就不用嵌套在一起了

  //标题方法
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left:10.0,top: 2.0,bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,color: Colors.black12
          )
        )
      ),
      child: Text(
        '商品推荐',
        style:TextStyle(
          color:Colors.pink
        )
      ),
    );
  }
  //商品单独项方法
  Widget _item(index,context){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, '/detail?id=${recommendList[index]["goodsId"]}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 0.5,
              color:Colors.black12
            )
          ),
          color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]["mallPrice"]}'),
            Text(
              '￥${recommendList[index]["price"]}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color:Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(380),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,//个数
        itemBuilder: (context,index){
          return _item(index,context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;

  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}
//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  Widget _goodsItem(Map goods,context){
    return Container(
      width: ScreenUtil().setWidth(370),
      child: InkWell(
        onTap: (){
          Application.router.navigateTo(context, '/detail?id=${goods["goodsId"]}');
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  Widget _firstRow(context){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0],context),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1],context),
            _goodsItem(floorGoodsList[2],context),
            
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3],context),
        _goodsItem(floorGoodsList[4],context),
        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context)
        ],
      ),
    );
  }
}

//火爆专区  触底加载
class HotGoods extends StatefulWidget {

  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    request('homePageBelowConten',formData: 1).then((res){
      print(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('1111111111111111111'),
    );
  }
}