import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/http_helper/HttpUtils.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'package:repair_server/model/bottom_button.dart';
import 'package:repair_server/order/chooseMaintainer.dart';
import 'package:repair_server/order/order_self.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';
import 'package:repair_server/http_helper/url_manager.dart';
import 'video_player_screen.dart';
import 'package:repair_server/http_helper/url_manager.dart';

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
      text: "抢单",
      onNext: _onNext,
      padingHorzation: 20.0,
    );
  }

  buildSuccess() {
    return NextButton(
      text: "确认完成",
      onNext: ()=>ApiRequest().success(context,widget.order.id).then((result){
        if(result){
          Navigator.pop(context);
        }
      }),
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
              onPressed: () => ApiRequest().captureOrder(context, widget.order.id).then((result) {
                    if(result){
                      Navigator.pop(context);
                    }
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
                ApiRequest().save(context, widget.order.id, num.parse(_rateController.text), num.parse(_quoteController.text))
                    .then((result) {
                      if(result){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
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
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
