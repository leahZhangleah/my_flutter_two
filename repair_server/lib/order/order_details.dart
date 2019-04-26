import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'order.dart';
import 'package:repair_server/url_manager.dart';
import 'video_player_screen.dart';

class OrderDetails extends StatefulWidget{
  Order order;
  OrderDetails({this.order});

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsState();
  }
}

class OrderDetailsState extends State<OrderDetails>{
  String _url;

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
        leading:IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
      ),
    body: Container(
      color: Colors.grey[300],
      child: ListView.builder(
        itemCount: 1,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context,index){
          return  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: <Widget>[
              buildOrderDescription(),//120
              buildOrderInfo(),
              buildOther(),//86
            ],
          );
      }),
    ),
    );
  }

  //公用行
  buildOrderInfo(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.order.contactsName),
              Container(padding: EdgeInsets.only(left: 10.0),
                  child: Text(widget.order.contactsPhone)),
            ],
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(widget.order.contactsAddress))
        ],
      ),
    );
  }

  //公用行
  buildOther() => new Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(10),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding:EdgeInsets.only(bottom: 10.0),
            child: Text("订单编号: "+widget.order.orderNumber)),
        Container(
          child: Divider(height: 1,color: Colors.grey[200]),
        ),
        Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text("下单时间: "+widget.order.createTime)),
      ],
    ) ,
  );

/*  buildDivider() =>new Container(
    height: 15,
    color: Colors.grey[300],
  );*/

  //第二块
  buildOrderDescription()=>new Container(
    color: Colors.white,
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
                widget.order.description,
                style: TextStyle(color: Colors.black)),
          ),
          Text(widget.order.type,style: TextStyle(color: Colors.grey[400])),
          /*Container(
            height: 100,
            child: new VideoPlayerScreen(url: _url,),
          )*/
          Container(
            width: 50,
              height: 50,
              child:GestureDetector(
                onTap: ()=>Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context){
                      return new VideoPlayerScreen(url:_url);
                    })),
                child: Image.asset("assets/images/video_thumbnail.jpeg"),
              ) )
        ],
      ),
    )
  );


  //最后一行
  buildBottomLine(){
    return Container(
      height: 60,
        color:Colors.grey[300] ,
        padding: EdgeInsets.only(right: 15,bottom: 10,top: 10),
        child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.all(
                      const Radius.circular(4.0)),
                  border: Border.all(width: 1, color: Colors.grey[500])
              ),
              width: 90,
              child: FlatButton(
                onPressed: null,
                child: Container(
                  child: Text("取消订单",
                      style: new TextStyle(color: Colors.black)),),
//                      borderSide:new BorderSide(width: 2,color: Colors.orange)
              ),)));
  }




}