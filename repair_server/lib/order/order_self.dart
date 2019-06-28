import 'package:flutter/material.dart';
import 'package:repair_server/model/behavior.dart';
import 'package:repair_server/order/maintainerfinish.dart';
import 'package:repair_server/order/missedorder.dart';
import 'package:repair_server/order/order_received.dart';
import 'package:repair_server/order/orderfinish.dart';
import 'package:repair_server/order/quotedorder.dart';
import 'package:repair_server/order/rfqorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfOrder extends StatefulWidget {

  final int sindex;
  SelfOrder({this.sindex});

  @override
  State<StatefulWidget> createState() {
    return SelfOrderState();
  }
}

class TabTitle{
  String title;
  int index;
  TabTitle(this.title, this.index);
}

class SelfOrderState extends State<SelfOrder>
    with SingleTickerProviderStateMixin {
  TabController mController;
  List<TabTitle> tabList;
  int currentPage;
  String type;

  @override
  void initState() {
    super.initState();
    getType();/*.then((_){
      initTabData();
    });*/

  }

  Future getType() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      type = sp.getString("type");
      type=="0"?
      tabList = [
        new TabTitle('待接单', 0),
        new TabTitle('待报价', 1),
        new TabTitle('已报价', 2),
        new TabTitle('已完成', 3)
      ]:tabList = [
        new TabTitle('待维修', 0),
        new TabTitle('已完成', 1)
      ];
      mController =
          TabController(length: tabList.length, vsync: this, initialIndex: 0);
    });
  }

 /* initTabData() {
    print(type);
    type=="0"?
    tabList = [
      new TabTitle('待接单', 0),
      new TabTitle('待报价', 1),
      new TabTitle('已报价', 2),
      new TabTitle('已完成', 3)
    ]:tabList = [
      new TabTitle('待维修', 0),
      new TabTitle('已完成', 1)
    ];

    mController =
        TabController(length: tabList.length, vsync: this, initialIndex: 0);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            "我的订单",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white24,
            indicatorColor: Colors.white,
            controller: mController,
            isScrollable: true,
            labelColor: Colors.white,
            tabs: tabList.map((item) {
              return Tab(
                  child: Text(item.title,
                      style: TextStyle(fontSize: 18, wordSpacing: 2)));
            }).toList(),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: TabBarView(
            controller: mController,
            children: tabList.map((item) {
              return Stack(
                children: <Widget>[
                  type=="0"?Center(
                      child: item.index == 0
                          ? OrderMissed()
                          : item.index == 1
                          ? OrderRFQ()
                          : item.index == 2 ? OrderQuote() : OrderFinish())
                      :Center(
                    child: item.index==0?OrderReceived():MaintainerFinish(),
                  )
                ],
              );
            }).toList(),
          ),
        ));
  }
}
