import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/model/bottom_button.dart';
import 'package:repair_server/order/chooseMaintainer.dart';
import 'package:repair_server/order/order_self.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';
import 'package:repair_server/url_manager.dart';
import 'video_player_screen.dart';

class OrderDetails extends StatefulWidget {
  Order order;

  OrderDetails({this.order});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsState();
  }
}

class OrderDetailsState extends State<OrderDetails> {
  String _url;
  num subscriptionMoney, subscriptionRate, balanceMoney, quoteMoney = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideoPlayer();
  }

  void initializeVideoPlayer() {
    UrlManager urlManager = new UrlManager();
    String baseUrl = urlManager.fileUploadServer;
    _url = baseUrl + widget.order.repairsOrdersDescriptionList[0].url;
    print(_url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("订单详情"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[300],
                  child: ListView.builder(
                      itemCount: 1,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildOrderDescription(), //120
                            buildOrderInfo(),
                            buildOther(),
                            widget.order.orderState >= 15
                                ? buildMoney()
                                : Container() //86
                          ],
                        );
                      }),
                )),
            widget.order.orderState == 5
                ? buildBottomLine()
                : widget.order.orderState == 10
                    ? buildBottomLineCapture()
                    : widget.order.orderState == 20
                        ? buildBottomLineAllot()
                        : widget.order.orderState == 25
                            ? buildSuccess()
                            : Container()
          ],
        ));
  }

  //公用行
  buildOrderInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                widget.order.contactsName,
                style: TextStyle(fontSize: 20),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.order.contactsPhone,
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                widget.order.contactsAddress,
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  buildMoney() => new Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("定金: ")),
                  Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("尾款: ")),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("￥" +
                          widget.order.repairsOrdersQuote.subscriptionMoney
                              .toString() +
                          "元")),
                  Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("￥" +
                          widget.order.repairsOrdersQuote.balanceMoney
                              .toString() +
                          "元")),
                ],
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text("总付款: ")),
              Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text("￥" +
                      widget.order.repairsOrdersQuote.quoteMoney.toString() +
                      "元"))
            ],
          )
        ],
      ));

  //公用行
  buildOther() => new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "订单编号: " + widget.order.orderNumber,
                  style: TextStyle(fontSize: 18),
                )),
            Container(
              child: Divider(height: 1, color: Colors.grey[200]),
            ),
            Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "下单时间: " + widget.order.createTime,
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
      );

  //第二块
  buildOrderDescription() => new Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Text(widget.order.description,
                  style: TextStyle(color: Colors.black, fontSize: 22)),
              margin: EdgeInsets.only(top: 5, bottom: 10),
            ),
            Container(
                height: 80,
                margin: EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                        return new VideoPlayerScreen(url: _url);
                      })),
                  child: Image.asset("assets/images/video_thumbnail.jpeg"),
                )),
            Text("#" + widget.order.type,
                style: TextStyle(color: Colors.lightBlue)),
          ],
        ),
      );

  //最后一行
  buildBottomLine() {
    return NextButton(
      text: "确认订单",
      onNext: _onNext,
      padingHorzation: 20.0,
    );
  }

  buildSuccess() {
    return NextButton(
      text: "维修完成",
      onNext: ()=>success(widget.order.id),
      padingHorzation: 20.0,
    );
  }

  buildBottomLineCapture() {
    return NextButton(
      text: "立即报价",
      onNext: _save,
      padingHorzation: 20.0,
    );
  }

  buildBottomLineAllot() {
    return NextButton(
      text: "分配订单",
      onNext: (){
        Navigator.push(context,
            new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new ChooseMaintainer(orderId:widget.order.id);
                }));
      },
      padingHorzation: 20.0,
    );
  }

  Future<void> captureOrder(String ordersId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        "/repairs/repairsOrdersMaintainer/captureOrder/$ordersId", null);
    print(response.data.toString());
  }

  _onNext() {
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
  }

  Future save(String id, num subscriptionMoney, num balanceMoney) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    quoteMoney = subscriptionMoney + balanceMoney;
    subscriptionRate =
        double.parse((subscriptionMoney / quoteMoney * 100).toStringAsFixed(2));
    ResultModel response =
        await RequestManager.requestPost("/repairs/repairsOrdersQuote/save", {
      "balanceMoney": balanceMoney,
      "quoteMoney": quoteMoney,
      "subscriptionMoney": subscriptionMoney,
      "repairsOrdersId": id,
      "subscriptionRate": subscriptionRate
    });
    print(response.data.toString());
  }

  _save() {
    final _controller = TextEditingController();
    final _rateController = TextEditingController();
    final _quoteController = TextEditingController();
    final _subController = TextEditingController();
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
                      _quoteController.text = (num.parse(_subController.text) +
                                  num.parse(_controller.text))
                              .toString() +
                          "元";
                      _rateController.text = (num.parse(_subController.text) /
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
                    _quoteController.text = (num.parse(_subController.text) +
                                num.parse(_controller.text))
                            .toString() +
                        "元";
                    _rateController.text = (num.parse(_subController.text) /
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
  }

  //维修完成
  Future<void> success(String ordersId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        "/repairs/repairsOrders/successMaintainer/$ordersId", null);
    print(response.data.toString());
    Navigator.pop(context);
  }
}
