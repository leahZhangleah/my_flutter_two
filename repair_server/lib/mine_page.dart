import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repair_server/http_helper/HttpUtils.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'package:repair_server/knowledge/knowledge_page.dart';
import 'package:repair_server/verification/identify.dart';
import 'package:repair_server/model/behavior.dart';
import 'package:repair_server/model/personalmodel.dart';
import 'package:repair_server/order/order_self.dart';
import 'package:repair_server/personal_info/personal.dart';
import 'package:repair_server/register.dart';
import 'package:repair_server/viewmodel/personal_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/comments/received_comments.dart';
import 'package:repair_server/http_helper/url_manager.dart';
class MinePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  num padingHorzation = 20;
  Size deviceSize;
  String name, image = "";
  var getInfo;

  @override
  void initState() {
    super.initState();
    //getInfo = getPersonalInfo();
    getInfo = ApiRequest().getPersonalInfo(context);
  }

  Future getPersonalInfo() async {
    ApiRequest().getPersonalInfo(context)/*.then((json){
      if(json!=null){
        setState(() {
          name = json
              .cast<String, dynamic>()['maintainerUser']['name'];

          image = json
              .cast<String, dynamic>()['maintainerUser']['headimg'];
        });
      }
    })*/;
  }

  @override
  Widget build(BuildContext context) {
    PersonalViewMModel vm = PersonalViewMModel();
    List<PersonalModel> data = vm.getPersonalItems();
    deviceSize = MediaQuery.of(context).size;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,), onPressed: ()=>Navigator.pop(context)),
        flexibleSpace: Container(
          color: Colors.lightBlue,
        ),
        bottom: PreferredSize(
            child: Container(
              height: 100,
              child: FutureBuilder(
                  builder: buildPersonalLine,
                  future:getInfo),
            ),
            preferredSize: Size(30, 80)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildAddressLine(index, data);
                        }))
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: RaisedButton(
            onPressed: ()=>ApiRequest().logout(context),
            child: Text(
              "退出登录",
              style: TextStyle(fontSize: 20),
            ),
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  Widget buildPersonalLine(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Center(child: Text('还没有开始网络请求'));
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        name = snapshot.data
            .cast<String, dynamic>()['maintainerUser']['name'];
        image = snapshot.data
            .cast<String, dynamic>()['maintainerUser']['headimg'];
        return new Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.only(left: 10, bottom: 10),
            height: 100,
            child: Center(
              child: ListTile(
                leading: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/person_placeholder.png",
                    fit: BoxFit.fitWidth,
                    image: UrlManager().fileUploadServer+image,
                    width: 75.0,
                    height: 75.0,
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                      letterSpacing: 0, fontSize: 20, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (c) {
                        return Personal(); //todo go to personal setting page
                      },
                    ),
                  ).then((_) {
                    ApiRequest().getPersonalInfo(context);
                    //getPersonalInfo();
                  });
                },
              ),
            ));
    }
  }

  Widget buildAddressLine(index, datas) {
    PersonalModel model = datas[index];
    return Container(
        color: Colors.white,
        height: 60,
        child: Column(children: <Widget>[
          Center(
            child: ListTile(
              leading: Icon(model.leadingIcon),
              title: Text(model.text),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
              onTap: () {
                index == 0
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return SelfOrder();//todo navigate to 我的订单
                    },
                  ),
                )
                    : index == 1
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new ReceivedComments();//todo navigate to 收到评价
                    },
                  ),
                ): index ==2
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return Identify();//TODO navigate to 认证信息
                    },
                  ),
                ):Navigator.push(context, new MaterialPageRoute(
                    builder: (context){
                      return new KnowledgePage();
                    }
                    )
                );
              },
            ),
          ),
          Container(
            child: Divider(height: 3, color: Colors.grey[300]),
            margin: EdgeInsets.only(left: 15, right: 15),
          )
        ]));
  }

}