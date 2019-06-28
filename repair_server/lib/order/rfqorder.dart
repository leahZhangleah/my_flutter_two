import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/http_helper/HttpUtils.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'package:repair_server/order/bottom_bar_helper.dart';
import 'package:repair_server/order/order.dart';
import 'package:repair_server/order/order_detail_bean/orders.dart';
import 'package:repair_server/order/order_details.dart';
import 'package:repair_server/order/order_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/http_helper/url_manager.dart';

class OrderRFQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderRFQState();
  }
}

class OrderRFQState extends State<OrderRFQ> with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  List<Orders> rfqOrder = [];
  int total = 0;
  num subscriptionMoney,subscriptionRate,balanceMoney,quoteMoney=0;

  @override
  void initState() {
    getYetReceiveOrder(nowPage, limit);
    super.initState();
  }

  //待报价订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    ApiRequest().getOrderListForDiffType(context, 0,nowPage, limit, "two").then((page){
      if(page!=null){
        setState(() {
          total = page.total;
          rfqOrder.addAll(page.orders);
        });
      }
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        rfqOrder.clear();
        getYetReceiveOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        if (rfqOrder.length >= total) {
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
    return Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                itemCount: rfqOrder.length==0?1:rfqOrder.length,
                itemBuilder: (context, index) {
                  if(rfqOrder==null||rfqOrder.length==0){
                    return Center(child:Text("暂无相关数据～"));
                  }
                  var missedOrder = rfqOrder[index];
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
                                    return new OrderDetails(orderId: missedOrder.id,);
                                  })),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/alucard.jpg",
                                                fit: BoxFit.fitWidth,
                                                image:
                                                    "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58",
                                                width: 50.0,
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text("报价员",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black))),
                                          ],
                                        ),
                                        Align(
                                          child: Text(
                                            "等待报价",
                                            style: TextStyle(
                                                color: Colors.lightBlue),
                                          ),
                                          alignment:
                                              FractionalOffset.centerRight,
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
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
                                 missedOrder.orderState == 7?
                                     BottomBarHelper().buildStatusButton("已接单"):
                                     BottomBarHelper().buildQuoteBtn(context, missedOrder.id)
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
