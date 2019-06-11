import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/order/order.dart';
import 'package:repair_server/order/order_details.dart';
import 'package:repair_server/order/order_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/url_manager.dart';

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
  List<Order> rfqOrder = [];
  int total = 0;
  String url = "";
  num subscriptionMoney,subscriptionRate,balanceMoney,quoteMoney=0;

  @override
  void initState() {
    getYetReceiveOrder(nowPage, limit);
    super.initState();
  }

  //待报价订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
       UrlManager().quoteList,
        {"nowPage": nowPage, "limit": limit, "typeList": "two"});
    print(response.data.toString());
    setState(() {
      total = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['page']['total'];
      rfqOrder.addAll(OrderResponse.fromJson(json.decode(response.data.toString()))
          .page
          .orders);
      url = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['fileUploadServer'];
    });
    print(rfqOrder.length);
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
    rfqOrder.clear();
    getYetReceiveOrder(nowPage, limit);
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

  Future save(String id,num subscriptionMoney,num balanceMoney) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    quoteMoney = subscriptionMoney + balanceMoney;
    subscriptionRate = num.parse((subscriptionMoney / quoteMoney * 100).toStringAsFixed(2));
    ResultModel response =
        await RequestManager.requestPost(UrlManager().saveQuote, {
      "balanceMoney": balanceMoney,
      "quoteMoney": quoteMoney,
      "subscriptionMoney": subscriptionMoney,
      "repairsOrdersId": id,
      "subscriptionRate": subscriptionRate
    });
    print(response.data.toString());

  }

  @override
  Widget build(BuildContext context) {

    final _controller = TextEditingController();
    final _rateController = TextEditingController();
    final _quoteController = TextEditingController();
    final _subController = TextEditingController();


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
                                    return new OrderDetails(order: missedOrder,);
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
                                  Align(
                                    alignment: FractionalOffset.bottomRight,
                                    child: OutlineButton(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.lightBlue),
                                        color: Colors.lightBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text("立即报价",
                                            style: new TextStyle(
                                                color: Colors.lightBlue)),
                                        onPressed: () {
                                          showDialog<bool>(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: CupertinoDialogAction(
                                                  child: Text(
                                                    "报价",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.black),
                                                  ),
                                                ),
                                                content: Card(
                                                  margin: EdgeInsets.all(0),
                                                  elevation: 0.0,
                                                  child: Column(
                                                    children: <Widget>[
                                                      TextField(
                                                        keyboardType: TextInputType.number,
                                                          inputFormatters: [WhitelistingTextInputFormatter(new RegExp('[0-9.,]'))],//BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]')),
                                                          controller:_subController,
                                                          onSubmitted: (text){
                                                            if(num.parse(_controller.text)>100){
                                                              Fluttertoast.showToast(msg: "定金比率不可以大于100");
                                                              _controller.clear();
                                                            }
                                                          },
                                                          onChanged: (text){
                                                            _quoteController.text=(num.parse(_subController.text) - num.parse(_subController.text)*num.parse(_controller.text)/100).toStringAsPrecision(4);
                                                            _rateController.text = (num.parse(_subController.text)*num.parse(_controller.text)/100).toStringAsPrecision(4);
                                                            //_rateController.text=(num.parse(_subController.text)*(num.parse(_controller.text))/100).toStringAsFixed(0)+"%";
                                                          },
                                                        decoration: InputDecoration(
                                                            labelText: "报价总金额",
                                                            filled: true,
                                                            fillColor: Colors.grey.shade50,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15.0),),
                                                      )),
                                                      Padding(padding: EdgeInsets.only(top: 5),),
                                                      TextField(
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [WhitelistingTextInputFormatter(new RegExp('[0-9.,]'))],
                                                        controller:_controller,
                                                          onChanged: (text){
                                                            _quoteController.text=(num.parse(_subController.text) - num.parse(_subController.text)*num.parse(_controller.text)/100).toStringAsPrecision(4);
                                                            _rateController.text = (num.parse(_subController.text)*num.parse(_controller.text)/100).toStringAsPrecision(4);
                                                          },
                                                        decoration: InputDecoration(
                                                          suffixText: "%",
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15.0),),
                                                            labelText: "定金比例",
                                                            filled: true,
                                                            fillColor: Colors.grey.shade50),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(top: 5),),
                                                      TextField(
                                                        enabled: false,
                                                        controller:_rateController,
                                                        decoration: InputDecoration(
                                                            suffixText: "元",
                                                            labelText: "订金",
                                                            filled: true,
                                                            fillColor: Colors.grey.shade50),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(top: 5),),
                                                      TextField(
                                                        enabled: false,
                                                        controller:_quoteController,
                                                        decoration: InputDecoration(
                                                          suffixText: "元",
                                                            labelText: "尾款",
                                                            filled: true,
                                                            fillColor: Colors.grey.shade50),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(top: 5),)
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    onPressed: (){
                                                        if(num.parse(_controller.text)>100){
                                                          Fluttertoast.showToast(msg: "定金比率不可以大于100");
                                                          _controller.clear();
                                                          return;
                                                        }
                                                      save(missedOrder.id,num.parse(_rateController.text),num.parse(_quoteController.text))
                                                          .then((_) {
                                                        Navigator.pop(context);
                                                        rfqOrder.clear();
                                                        getYetReceiveOrder(1, 5);
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        "确定",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  CupertinoDialogAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        "取消",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
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
                })));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
