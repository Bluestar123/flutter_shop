import 'package:flutter/material.dart';

//混入   必须
class Counter with ChangeNotifier{
  int value = 0;

  increment(){
    value++;

    notifyListeners();//通知 改变东西了请刷新，，局部刷新
  }
}