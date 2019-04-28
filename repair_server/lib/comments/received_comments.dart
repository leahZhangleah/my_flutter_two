import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'comment.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comment_response.dart';
import 'one_comment.dart';
import 'package:repair_server/url_manager.dart';
import 'package:repair_server/register.dart';

class ReceivedComments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReceivedCommentsState();
  }
}

class ReceivedCommentsState extends State<ReceivedComments> with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Comment> comments;
  String url = "";

  @override
  void initState() {

    super.initState();
    UrlManager urlManager = new UrlManager();
    url = urlManager.receiveAppraiseList;
    comments=new List();
    _getReceivedComments(nowPage, limit);
  }

  //待报价订单列表
  Future<void> _getReceivedComments(int nowPage, int limit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        url,
        {"nowPage": nowPage, "limit": limit});
    print(response.data.toString());
    var json = jsonDecode(response.data.toString());
    if(json["msg"]=="token失效，请重新登录"){
      Fluttertoast.showToast(msg: "登录信息已失效，请重新登录");
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new RegisterScreen()
          ),  ModalRoute.withName('/'),);
    }
    setState(() {
      Page page = CommentResponse.fromJson(json).page;
      total = page.total;
      comments.addAll(page.comments);
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        comments.clear();
        _getReceivedComments(nowPage,limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      if(comments.length < total){
        setState(() {
          nowPage+=1;
          _getReceivedComments(nowPage,limit);
        });
      }else{
        Fluttertoast.showToast(msg: "没有更多的评价了");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收到评价"),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Refresh(
              child:
                comments.length==0?
                  SingleChildScrollView(
                      child:Align(
                        alignment: AlignmentDirectional.center,
                        child: Text("目前还没有评价"),
                      )
                  )
                :
                buildCommentsList(comments),
              onFooterRefresh: onFooterRefresh,
              onHeaderRefresh: onHeaderRefresh,
              )),
    );
  }

  Widget buildCommentsList(List<Comment> comments){
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          var comment = comments[index];
          return OneComment(comment: comment,);
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}