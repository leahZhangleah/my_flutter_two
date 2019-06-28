import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'package:repair_server/order/one_order.dart';
import 'package:repair_server/order/order_detail_bean/orders.dart';
import 'package:repair_server/order/order_list_bean/page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mine_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/custom_icons/sign_scan_icons.dart';

//import 'package:barcode_scan/barcode_scan.dart';

class MainPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();
  }

}
//type 0：报价员 1：维修员
class MainPageState extends State<MainPage>{
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Orders> orderList = [];
  var getOrders;
  String barcode;

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        if (orderList.length >= total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          nowPage += 1;
          //_fetchOrders(nowPage, limit);
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
        //orderList.clear();
        //_fetchOrders(nowPage, limit);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders = _fetchOrders(nowPage, limit);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修一修"),
        centerTitle: true,
        leading:IconButton(
            icon: Icon(Sign_scan.qrcode,color: Colors.white,),
            onPressed: ()=>scan()),
        actions: <Widget>[
          Center(
            child: IconButton(
                icon: Icon(Icons.person,color: Colors.white,),
                onPressed: ()=>Navigator.push(context, new MaterialPageRoute(
                    builder: (context){
                      return new MinePage();
                    })).then((_){
                  _fetchOrders(nowPage, limit);
                })),//todo leading to personal page
          )
        ],
      ),
      body: OrderList(),
    );
  }

  Future scan() async {
    /*try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        return this.barcode = barcode;
      });
    } *//*on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = '用户未授权使用相机';
        });
      } else {
        setState(() {
          return this.barcode = '未知错误: $e';
        });
      }
    }*//* on FormatException {
      setState(() => this.barcode = 'null (用户为扫描二维码)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown 未知错误: $e');
    }*/
  }


  Widget OrderList(){
    return FutureBuilder<Page>(
        //decoration: BoxDecoration(color: Colors.grey[200]),
        future: getOrders,
        builder: (BuildContext context, AsyncSnapshot<Page> snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('还没有开始网络请求');
            case ConnectionState.active:
              return Text('ConnectionState.active');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if(snapshot.data!=null){
                total = snapshot.data.total;
                orderList = snapshot.data.orders;
                return Refresh(
                    onFooterRefresh: onFooterRefresh,
                    onHeaderRefresh: onHeaderRefresh,
                    child: ListView.builder(
                        itemCount: orderList.length==0?1:orderList.length,
                        itemBuilder: (context, index) {
                          if(orderList.length==0){
                            return Center(child:Text("暂无相关数据～"));
                          }else{
                            return OneOrder(order:orderList[index]) ;
                          }//order: orders[index],
                        }));
              }else{
                return Container(
                  child: Text("获取订单错误，请稍后再试"),
                );
              }

          }
        }

    );
  }


  Future<Page> _fetchOrders(int nowPage, int limit) async {
    int userType;
    String typeList;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String type = sp.getString("type");
    type=="0"?typeList="five":typeList="three";
    type=="0"?userType=0:userType=1;          //0:报价员，1：维修员
    return ApiRequest().getOrderListForDiffType(context, userType, nowPage, limit, typeList);
  }

}

