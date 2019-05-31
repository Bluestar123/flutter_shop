import 'package:flutter/material.dart';
import './index_page.dart';

class AnimatePage extends StatefulWidget {
  final Widget child;

  AnimatePage({Key key, this.child}) : super(key: key);

  _AnimatePageState createState() => _AnimatePageState();
}

class _AnimatePageState extends State<AnimatePage> with SingleTickerProviderStateMixin {


  AnimationController _animationController;
  Animation _animation;

  void initState() { 
    super.initState();
    _animationController =AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
    );

    _animation=Tween(begin: 0.0,end: 1.0).animate(_animationController);

    _animationController.addStatusListener((status){
      if(status==AnimationStatus.completed){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context){
            return IndexPage();
          }), (route)=>route==null);
      }
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: FadeTransition(
         opacity: _animation,
         child: Image.network('https://icweiliimg1.pstatp.com/weili/bl/57461980914657774.jpg'),
       ),
    );
  }
}