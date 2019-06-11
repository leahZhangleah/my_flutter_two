import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/order/order.dart';
import 'package:repair_server/order/order_details.dart';
import 'package:repair_server/order/order_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/url_manager.dart';

class OrderFinish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderFinishState();
  }
}

class OrderFinishState extends State<OrderFinish>
    with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Order> _finishedOrder = [];

  @override
  void initState() {
    getYetReceiveOrder(nowPage, limit);
    super.initState();
  }

  //未接单订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        UrlManager().quoteList,
        {"nowPage": nowPage, "limit": limit, "typeList": "four"});
    print(response.data.toString());
    setState(() {
      _finishedOrder.addAll(OrderResponse.fromJson(json.decode(response.data.toString())).page.orders);
      total = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['page']['total'];
    });
    print(total);
  }

  //取消订单
  Future<void> cancelorder(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        UrlManager().cancelOrder+id, null);
    print(response.data.toString());
    nowPage = 1;
    limit = 5;
    _finishedOrder.clear();
    getYetReceiveOrder(nowPage, limit);
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        _finishedOrder.clear();
        getYetReceiveOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        if (_finishedOrder.length >= total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          nowPage += 1;
          getYetReceiveOrder(nowPage, limit);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                itemCount: _finishedOrder.length==0?1:_finishedOrder.length,
                itemBuilder: (context, index) {
                  if(_finishedOrder==null||_finishedOrder.length==0){
                    return Center(child:Text("暂无相关数据～"));
                  }
                  var finishOrder = _finishedOrder[index];
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
                                        return new OrderDetails(order: finishOrder,);
                                      })),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 20),
                                                  child: Text(
                                                      finishOrder.description,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                          Colors.black))),
                                              Text(
                                                "#" + finishOrder.type,
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  child: Text(
                                                      finishOrder.createTime,
                                                      style: TextStyle(
                                                          color: Colors.grey)))
                                            ],
                                          )),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            child: Text(
                                              "定金：" +
                                                  finishOrder.repairsOrdersQuote
                                                      .subscriptionMoney
                                                      .toString() +
                                                  "元",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            padding: EdgeInsets.only(top: 10),
                                          ),
                                          Padding(
                                            child: Text(
                                              "尾款：" +
                                                  finishOrder.repairsOrdersQuote
                                                      .balanceMoney
                                                      .toString() +
                                                  "元",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            padding: EdgeInsets.only(top: 10),
                                          ),
                                          Padding(
                                            child: Text(
                                              "合计：" +
                                                  finishOrder.repairsOrdersQuote
                                                      .quoteMoney
                                                      .toString() +
                                                  "元",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            padding: EdgeInsets.only(top: 10),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.bottomRight,
                                    child: OutlineButton(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.lightBlue),
                                        color: Colors.lightBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: finishOrder.orderState==35?Text("待评价",
                                            style: new TextStyle(
                                                color: Colors.lightBlue)):Text("已评价",
                                            style: new TextStyle(
                                                color: Colors.lightBlue))),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                })));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
