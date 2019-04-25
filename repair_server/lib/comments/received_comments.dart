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
  var getComments;

  @override
  void initState() {

    super.initState();
    UrlManager urlManager = new UrlManager();
    url = urlManager.receiveAppraiseList;
    comments=new List();
    getComments=_getReceivedComments(nowPage, limit);
  }

  //待报价订单列表
  Future<List<Comment>> _getReceivedComments(int nowPage, int limit) async {
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
      Navigator.push(context, new MaterialPageRoute(
          builder: (context){
            return new RegisterScreen();
          }));
    }
    Page page = CommentResponse.fromJson(json).page;
    total = page.total;
    comments.addAll(page.comments);
    return comments;
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        comments.clear();
        //getComments = _getReceivedComments(nowPage,limit);
        //_getReceivedComments(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      if(comments.length < total){
        setState(() {
          nowPage+=1;
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
        title: Text("评价"),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Refresh(
              childBuilder: (BuildContext context,
                  {ScrollController controller, ScrollPhysics physics}){
                return FutureBuilder<List<Comment>>(
                    future: getComments,//todo
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.done){
                        if(snapshot.hasError){
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }else if(snapshot.hasData){
                          //comments.addAll(snapshot.data);//todo to be adjusted
                          return buildCommentsList(comments);
                        }else{
                          return Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Text("目前还没有评价"),
                          );
                        }
                      }else if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(
                            child:new CircularProgressIndicator()
                        );
                      }
                    });
              },
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

  _buildRefreshBody() {

  }
}