import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/MainPage.dart';
import 'package:repair_server/order/chooseMaintainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';
import 'package:repair_server/order/order_details.dart';
import 'package:repair_server/url_manager.dart';

//维修员
class OneOrder extends StatefulWidget {
  Order order;

  OneOrder({this.order});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OneOrderState();
  }
}

class OneOrderState extends State<OneOrder> {
  num subscriptionMoney, subscriptionRate, balanceMoney, quoteMoney = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new OrderDetails(
                        order: widget.order,
                      );
                    })),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("订单编号："),
                          Text(widget.order.orderNumber),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text(widget.order.description,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black))),
                            Text(
                              "#" + widget.order.type,
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(widget.order.updateTime,
                                    style: TextStyle(color: Colors.grey)))
                          ],
                        ),
                        widget.order.orderState >= 15
                            ? Column(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5.0, bottom: 5),
                                      child: Text(
                                          "定金:" +
                                              widget.order.repairsOrdersQuote
                                                  .subscriptionMoney
                                                  .toString() +
                                              "元",)),
                                  Text(
                                    "尾款:" +
                                        widget.order.repairsOrdersQuote
                                            .balanceMoney
                                            .toString() +
                                        "元",
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                          "总付款:" +
                                              widget.order.repairsOrdersQuote
                                                  .quoteMoney
                                                  .toString() +
                                              "元",))
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    widget.order.orderState == 10
                        ? buildRFQ()
                        : widget.order.orderState == 5
                            ? buildMissedOrder()
                            : widget.order.orderState == 20
                                ? buildQuoteOrder()
                                : buildOverOrder()
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildOverOrder() {
    return Align(
        alignment: FractionalOffset.bottomRight,
        child: OutlineButton(
            borderSide: BorderSide(width: 1, color: Colors.lightBlue),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text("确认完成", style: new TextStyle(color: Colors.lightBlue)),
            onPressed: () {
              showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: CupertinoDialogAction(
                      child: Text(
                        "确定维修已全部完成？",
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                      ),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () => success(widget.order.id),
                        child: Container(
                          child: Text(
                            "确定",
                            style: TextStyle(fontSize: 16, color: Colors.black),
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
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }));
  }

  //分配订单
  Widget buildQuoteOrder() {
    return Align(
        alignment: FractionalOffset.bottomRight,
        child: OutlineButton(
            borderSide: BorderSide(width: 1, color: Colors.lightBlue),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text("分配订单", style: new TextStyle(color: Colors.lightBlue)),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new ChooseMaintainer(orderId: widget.order.id);
              })).then((_) {});
            }));
  }

  //确认订单
  Widget buildMissedOrder() {
    return Align(
      alignment: FractionalOffset.bottomRight,
      child: OutlineButton(
          borderSide: BorderSide(width: 1, color: Colors.lightBlue),
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text("确认订单", style: new TextStyle(color: Colors.lightBlue)),
          onPressed: () {
            showDialog<bool>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: CupertinoDialogAction(
                    child: Text(
                      "是否确认订单？",
                      style: TextStyle(fontSize: 18, color: Colors.redAccent),
                    ),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      onPressed: () => captureOrder(widget.order.id).then((_) {
                            Navigator.pop(context);
                          }),
                      child: Container(
                        child: Text(
                          "确定",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  //立即报价
  Widget buildRFQ() {
    final _controller = TextEditingController();
    final _rateController = TextEditingController();
    final _quoteController = TextEditingController();
    final _subController = TextEditingController();

    return Align(
      alignment: FractionalOffset.bottomRight,
      child: OutlineButton(
          borderSide: BorderSide(width: 1, color: Colors.lightBlue),
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text("立即报价", style: new TextStyle(color: Colors.lightBlue)),
          onPressed: () {
            showDialog<bool>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: CupertinoDialogAction(
                    child: Text(
                      "报价金额",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  content: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 0.0,
                    child: Column(
                      children: <Widget>[
                        TextField(
                            controller: _subController,
                            onChanged: (text) {
                              _quoteController.text =
                                  (num.parse(_subController.text) +
                                              num.parse(_controller.text))
                                          .toString() +
                                      "元";
                              _rateController
                                  .text = (num.parse(_subController.text) /
                                          (num.parse(_controller.text) +
                                              num.parse(_subController.text)) *
                                          100)
                                      .toStringAsFixed(0) +
                                  "%";
                            },
                            decoration: InputDecoration(
                              labelText: "预付订金",
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        TextField(
                          controller: _controller,
                          onChanged: (text) {
                            _quoteController.text =
                                (num.parse(_subController.text) +
                                            num.parse(_controller.text))
                                        .toString() +
                                    "元";
                            _rateController
                                .text = (num.parse(_subController.text) /
                                        (num.parse(_controller.text) +
                                            num.parse(_subController.text)) *
                                        100)
                                    .toStringAsFixed(0) +
                                "%";
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: "尾款",
                              filled: true,
                              fillColor: Colors.grey.shade50),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        TextField(
                          enabled: false,
                          controller: _rateController,
                          decoration: InputDecoration(
                              labelText: "订金比率",
                              filled: true,
                              fillColor: Colors.grey.shade50),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        TextField(
                          enabled: false,
                          controller: _quoteController,
                          decoration: InputDecoration(
                              labelText: "总金额",
                              filled: true,
                              fillColor: Colors.grey.shade50),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      onPressed: () => save(
                                  widget.order.id,
                                  double.parse(_subController.text),
                                  double.parse(_controller.text))
                              .then((_) {
                        Navigator.pop(context);
                          }),
                      child: Container(
                        child: Text(
                          "确定",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Future save(String id, num subscriptionMoney, num balanceMoney) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    quoteMoney = subscriptionMoney + balanceMoney;
    subscriptionRate =
        double.parse((subscriptionMoney / quoteMoney * 100).toStringAsFixed(2));
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

  Future<void> captureOrder(String ordersId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        UrlManager().captureOrder+ordersId, null);
    print(response.data.toString());
  }

  //维修完成
  Future<void> success(String ordersId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        UrlManager().finishMaintain+ordersId, null);
    print(response.data.toString());
  }
}
