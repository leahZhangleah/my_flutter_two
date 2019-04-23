import 'package:flutter/material.dart';

class OrderDetiails extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return OrderDetiailsState();
  }

}

class OrderDetiailsState extends State<OrderDetiails>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单详情"),
        centerTitle: true,
        leading:IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
      ),
    body: ListView.builder(
      itemCount: 1,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context,index){
        return  Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            buildOrderState(),//80
            buildWorkerLine(),//50
            Container(//1
              margin: EdgeInsets.only(left: 15,right: 15),
              child: Divider(height: 1,color: Colors.grey)
            ),
            buildOrderDestription(),//120
            buildDivider(),//15
            buildOrderInfo(),//75
            buildDivider(),//15
            buildOther(),//86
            buildDivider(),//15
            buildBottomLine(),//60
            Container(height: 1)
          ],
        );
    }),
    );
  }

  //公用行
  buildOrderInfo(){
    return Container(
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("用户姓名"),
              SizedBox(width: 20),
              Text("13564793024"),
            ],
          ),
          SizedBox(height: 10),
          Text("广东省深圳市 南山区 深南大道 123344好号")
        ],
      ),
    );
  }

  //公用行
  buildOther() => new Container(
    height: 85,
    margin: EdgeInsets.only(left: 10,top: 10),
//    child: Text("等待报价",style: TextStyle(color: Colors.black)),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(padding: EdgeInsets.only(top: 10,bottom: 10),child: Text("订单编号: 14324234234234")),
        Container(
          margin: EdgeInsets.only(left: 0,right: 15),
          child: Divider(height: 1,color: Colors.grey),
        ),
        Container(padding: EdgeInsets.only(top: 10,bottom: 10),child: Text("下单时间: 2019-01-01  12:00")),
      ],
    ) ,
  );

  buildDivider() =>new Container(
    height: 15,
    color: Colors.grey[300],
  );

  //第一块 高度75
 buildOrderState()=>new Container(
   height: 80,
   color: Colors.grey[300],
   padding: EdgeInsets.only(top: 15,bottom: 15,left: 15),
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Text("未接单",style: TextStyle(color: Colors.black)),
       SizedBox(height:10),
     ],
   ),
 );

  //第二块
  buildOrderDestription()=>new Container(
    height: 120,
    color: Colors.white,
    padding: EdgeInsets.only(top: 10,bottom: 10,left: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 200,
              child: Text("墙体裂缝是建筑解耦的墙体布丁粉产生的开裂县现象，按照材料自身材质的不同，.......",style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height:10),
            Text("#墙面开裂",style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ],
    )
  );

  Widget buildWorkerLine() => new Container(
      padding: EdgeInsets.only(left: 0, right: 10),
      height: 50,
      color: Colors.white,
      child: Center(
        child: ListTile(
          leading: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/alucard.jpg",
              fit: BoxFit.fitWidth,
              image:
              "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58",
              width: 40.0,
              height: 40.0,
            ),
          ),
          title: Text("维修师傅"),
        ),
      ));

  buildCurrentState(){
    return new Container(
      margin: EdgeInsets.only(right:10,top: 10),
      child:Column(
            children: <Widget>[
              Text("定金: ￥50.00元"),
              Text("尾款: ￥50.00元"),
              SizedBox(height: 20),
              Text("合计: ￥100.00元"),
            ],
    ));
  }

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