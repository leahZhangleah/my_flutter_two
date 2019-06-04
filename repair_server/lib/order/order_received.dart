import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/order/order.dart';
import 'package:repair_server/order/order_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/order/order_details.dart';

class OrderReceived extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderReceivedState();
  }
}

class OrderReceivedState extends State<OrderReceived>
    with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  String url = "";
  List<Order> mo;
  var getOrder;

  @override
  void initState() {
    getOrder = getYetReceiveOrder(nowPage, limit);
    super.initState();
  }

  //维修完成
  Future<void> success(String ordersId) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost("/repairs/repairsOrders/successMaintainer/$ordersId",null);
    print(response.data.toString());
  }

  //已接单订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        "/repairs/repairsOrders/maintainerList",
        {"nowPage": nowPage, "limit": limit, "typeList": "one"});
    print(response.data.toString());
    setState(() {
      mo = OrderResponse.fromJson(json.decode(response.data.toString()))
          .page
          .orders;
      total = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['page']['total'];
    });
    print(total);
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        getYetReceiveOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage += 5;
        limit += 5;
        if (nowPage > total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          getYetReceiveOrder(1, limit);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: FutureBuilder(builder: buildPersonalLine, future: getOrder));
  }

  Widget buildPersonalLine(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Center(child: Text('还没有开始网络请求'));
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                itemCount: mo.length,
                itemBuilder: (context, index) {
                  var missedOrder = mo[index];
                  return Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.push(context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return new OrderDetails(order: missedOrder,);
                                  })),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 20),
                                      child: Text(missedOrder.description,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Text(
                                    "#" + missedOrder.type,
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(missedOrder.createTime,
                                          style:
                                              TextStyle(color: Colors.grey))),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.bottomRight,
                                    child: missedOrder.orderState == 30
                                        ? OutlineButton(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.lightBlue),
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Text("待付尾款",
                                                style: new TextStyle(
                                                    color: Colors.lightBlue)),
                                          )
                                        : OutlineButton(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.lightBlue),
                                            color: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Text("维修完成",
                                                style: new TextStyle(
                                                    color: Colors.lightBlue)),
                                            onPressed: () {
                                              showDialog<bool>(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title:
                                                        CupertinoDialogAction(
                                                      child: Text(
                                                        "确定维修已全部完成？",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        onPressed: () => success(missedOrder.id),
                                                        child: Container(
                                                          child: Text(
                                                            "确定",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      CupertinoDialogAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            "取消",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }));
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
