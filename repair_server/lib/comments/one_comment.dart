import 'package:flutter/material.dart';
import 'comment.dart';
class OneComment extends StatefulWidget{
  Comment comment;

  OneComment({this.comment});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OneCommentState();
  }

}

class OneCommentState extends State<OneComment> {
  Comment comment;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*this.id,
    this.ordersId,
    this.ordersNumber,
    this.ordersDescription,
    this.ordersType,
    this.content,
    this.starLevel,
    this.createUserId,
    this.createUserName,
    this.createUserHeadimg,
    this.createTime,
    this.updateTime,*/
    comment= new Comment(
      id: "1",
      ordersId: "2",
      ordersNumber: "3456",
      ordersDescription: "what are you talking about",
      ordersType: "墙面开裂",
      content: "一般",
      starLevel: 4,
      createUserId: "789",
      createUserName: "ridiculous",
      createUserHeadimg: "/uploadFile/img/img-a240f811gy1g26xf52xdag20h40rdqv5.gif",
      createTime:"2019-04-23 10:41:06",
      updateTime: "2019-04-23 10:41:06"
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return /*Scaffold(
      appBar: AppBar(
        title: Text("评价"),
        centerTitle: true,
      ),*/
      InkWell(
        onTap: null,//todo if there's more detailed page
        child: Container(
          //padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
            margin: EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildUser(widget.comment), //todo replace it with widget.comment
                  Divider(height: 2,color: Colors.grey,),
                  _buildContent(widget.comment),//todo replace it with widget.comment
                  _buildOrder(widget.comment),//todo replace it with widget.comment
                ],
              ),
            )),
      );
  }

  Widget _buildUser(Comment comment){
    List<String> updateTime = comment.updateTime.split(" ");
    String date = updateTime[0];
    String time = updateTime[1];
    return Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/alucard.jpg",
                  fit: BoxFit.fitWidth,
                  image: "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58",//todo
                  width: 35.0,),
              ),
              Padding(
                  padding:EdgeInsets.only(left: 20),
                  child:Text(
                      comment.createUserName,
                      style: TextStyle(color: Colors.black,fontSize: 18,)
                  )
              ),
            ],),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8.0,right: 20.0,bottom: 8.0),
                child: Text(
                  date,
                  style: TextStyle(color: Colors.grey,fontSize: 14.0),),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey,fontSize: 14.0),)
            ],
          )
        ],),);
  }

  Widget _buildContent(Comment comment){
    return Padding(
        padding:
        EdgeInsets.only(top: 20, bottom: 20),
        child: Text(
            comment.content,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black)));
  }

  Widget _buildOrder(Comment comment) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.grey
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            comment.ordersDescription,
            style: TextStyle(color: Colors.black,fontSize: 16.0),
          ),
          Text(
            "#"+comment.ordersType,
            style: TextStyle(color: Colors.blue,fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}