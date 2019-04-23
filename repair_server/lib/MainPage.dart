import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:repair_server/order_details.dart';
import 'package:repair_server/date_format.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();
  }

}

class MainPageState extends State<MainPage>{

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
//      setState(() {
//        nowPage += 5;
//        limit += 5;
//        if (nowPage > total) {
//          Fluttertoast.showToast(msg: "没有更多的订单了");
//        } else {
//          getYetReceiveOrder(nowPage, limit);
//        }
//      });
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
//      setState(() {
//        nowPage = 1;
//        limit = 5;
//        getYetReceiveOrder(nowPage, limit);
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修一修"),
        centerTitle: true,
        leading:IconButton(icon: Icon(Icons.book,color: Colors.white,), onPressed: null),
        actions: <Widget>[
          Center(child: IconButton(icon: Icon(Icons.person,color: Colors.white,), onPressed: null),)
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
                itemCount: 5,
                itemBuilder: (context, index) {
//                  var missedOrder = _yetReceiveOrder[index];
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
                                        return new OrderDetiails();
                                      })),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                      EdgeInsets.only(top: 5, bottom: 20),
                                      child: Text("这里是损坏的描述信息",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Text(
                                    "#墙面开裂",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(formatDate(DateTime.now(), [yyyy,'-',mm,'-',dd ,"  ",HH,':',nn,':',ss]),
                                          style:
                                          TextStyle(color: Colors.grey))),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                      alignment: FractionalOffset.bottomRight,
                                      child: RaisedButton(
                                        highlightColor: Colors.lightBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        onPressed: null,
                                        child: Container(
                                          child: Text("确认订单",
                                              style: new TextStyle(
                                                  color: Colors.lightBlue)),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                })));
  }
}

