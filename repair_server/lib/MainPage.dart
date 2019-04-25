import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:repair_server/order/one_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/HttpUtils.dart';
import 'mine_page.dart';
import 'knowledge/knowledge_page.dart';
import 'order/order.dart';
import 'url_manager.dart';
import 'dart:convert';
import 'package:repair_server/order/order_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'register.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();
  }

}

class MainPageState extends State<MainPage>{
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  String url = "";
  String typeList = "three"; //stands for 已报价
  List<Order> orderList = [];
  var getOrders;
  UrlManager _urlManager;

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {

      setState(() {
        nowPage += 1;
        //limit += 5;
        if (orderList.length >= total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          _fetchOrders(nowPage, limit,typeList);
        }
      });
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        orderList.clear();
        _fetchOrders(nowPage, limit, typeList);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _urlManager = new UrlManager();
    url = _urlManager.maintainerList;
    //orderList = new List();
    _fetchOrders(nowPage, limit, typeList);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修一修"),
        centerTitle: true,
        leading:IconButton(
            icon: Icon(Icons.book,color: Colors.white,),
            onPressed: ()=>Navigator.push(context, new MaterialPageRoute(
                builder: (context){
                  return new KnowledgePage();
                }))),
        actions: <Widget>[
          Center(
            child: IconButton(
                icon: Icon(Icons.person,color: Colors.white,),
                onPressed: ()=>Navigator.push(context, new MaterialPageRoute(
                    builder: (context){
                      return new MinePage();
                    }))),//todo leading to personal page
          )
        ],
      ),
      body: OrderList(),
    );
  }


  Widget OrderList(){
    return Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                itemCount: orderList==null?0:orderList.length,
                itemBuilder: (context, index) {
//                  var missedOrder = _yetReceiveOrder[index];
                  return new OneOrder(order:orderList[index]) ;//order: orders[index],
                })));
  }

  Future<void> _fetchOrders(int nowPage, int limit,String typeList) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        url,
        {"nowPage": nowPage, "limit": limit,"typeList":typeList});
    print(response.data.toString());
    var json = jsonDecode(response.data.toString());
    //todo parse json as below
    if(json["msg"]=="token失效，请重新登录"){
      Fluttertoast.showToast(msg: "登录信息已失效，请重新登录");
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context){
            return new RegisterScreen();
          }));
    }

    setState(() {
      OrderResponse orderResponse = OrderResponse.fromJson(json);
      //_urlManager.fileUploadServer = orderResponse.fileUploadServer;
      Page page= orderResponse.page;
      total = page.total;
      orderList.addAll(page.orders);
    });
    /*total = CommentResponse.fromJson(json).page.total;
    return CommentResponse.fromJson(json).page.comments;*/
  }

}

