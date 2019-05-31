import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './cart_page.dart';
import './category_page.dart';
import './home_page.dart';
import './member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';


//静态组件
class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs=[
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
      // icon:Image.asset('images/button_01a.png',width: 20.0,height: 20.0,),
      // activeIcon: Image.asset('images/button_01b.png',width: 20.0,height: 20.0,),
      icon: Icon(CupertinoIcons.search),
      title: Text('分类')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心')
    ),
  ];


  //必须加widget
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =ScreenUtil(width: 750,height: 1334)..init(context);//放在build里面初始化
    return Provide<CurrentIndexProvide>(
      builder: (context,child,data){
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),//全局的背景色
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: bottomTabs,
              onTap: (index){
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
            body: IndexedStack(
              index: currentIndex,
              children: tabBodies,
            )
        );
      },
    );
  }
}



//底栏切换 动态切换  需要动态组件
// class IndexPage extends StatefulWidget {
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
  
//   //底栏的图标 文字 list  
//   //final 常量  不变
//   final List<BottomNavigationBarItem> bottomTabs=[
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.home),
//       title: Text('首页')
//     ),
//     BottomNavigationBarItem(
//       // icon:Image.asset('images/button_01a.png',width: 20.0,height: 20.0,),
//       // activeIcon: Image.asset('images/button_01b.png',width: 20.0,height: 20.0,),
//       icon: Icon(CupertinoIcons.search),
//       title: Text('分类')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.shopping_cart),
//       title: Text('购物车')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.profile_circled),
//       title: Text('会员中心')
//     ),
//   ];


//   //必须加widget
//   final List<Widget> tabBodies = [
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];

//   int currentIndex = 0;//当前选择第几个
//   var currentPage;

//   //初始化页面
//   @override
//   void initState() {
//     currentPage = tabBodies[currentIndex];//默认第一个页面
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance =ScreenUtil(width: 750,height: 1334)..init(context);//放在build里面初始化
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),//全局的背景色
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         items: bottomTabs,
//         onTap: (index){

//           if(currentIndex==index){
//             print('111111');
//           }
//           setState(() { //改变状态值 必须用setState
//            currentIndex=index; 
//            currentPage=tabBodies[currentIndex];
           
//           });
          
//         },
//       ),
//       body: IndexedStack(
//         index: currentIndex,
//         children: tabBodies,
//       ),
//     );
//   }
// }


// class IndexPage extends StatelessWidget { //静态组件 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('百姓生活+')),
//       body:Center(
//         child: Text('77777777777777'),
//       )
//     );
//   }
// }