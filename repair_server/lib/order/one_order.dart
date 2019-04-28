import 'package:flutter/material.dart';
import 'order.dart';
import 'package:repair_server/order/order_details.dart';
import 'package:repair_server/date_format.dart';
class OneOrder extends StatefulWidget{
  Order order;

 OneOrder({this.order});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OneOrderState();
  }

}

class OneOrderState extends State<OneOrder> {

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
                    new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new OrderDetails(order: widget.order,);
                        })),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
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
                    Padding(
                        padding:
                        EdgeInsets.only(top: 8.0, bottom: 20),
                        child: Text(widget.order.description,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black))),
                    Text(
                      "#"+widget.order.type,
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(widget.order.updateTime,//formatDate(DateTime.now(), [yyyy,'-',mm,'-',dd ,"  ",HH,':',nn,':',ss])
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
                          onPressed: null,//todo
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
  }
}