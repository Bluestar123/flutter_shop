import 'package:flutter/material.dart';

import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './loading.dart';
import './cart_child/cart_item.dart';
import './cart_child/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List cartList = Provide.value<CartProvide>(context).cartList;

            return Stack(
              children:<Widget>[
                Provide<CartProvide>(
                  builder: (context,child,data){
                    cartList=Provide.value<CartProvide>(context).cartList;
                   
                    return ListView.builder(
                      itemCount:cartList.length,
                      itemBuilder:(context,index){
                        return CartItem(cartList[index]);
                      }
                    );
                  },
                ),
                Positioned(
                  left:0,
                  bottom:0,
                  child:CartBottom()
                )
              ]
            );

          }else{
            return Loading();
          }
        },
      ),
    );
  }


  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}