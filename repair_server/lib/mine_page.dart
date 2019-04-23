import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/model/behavior.dart';
import 'package:repair_server/model/personalmodel.dart';
import 'package:repair_server/viewmodel/personal_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> {
  @override
  bool get wantKeepAlive => true;
  num padingHorzation = 20;
  Size deviceSize;
  String name, image = "";
  var getInfo;

  @override
  void initState() {
    super.initState();
    getInfo = getPersonalInfo();
  }

  Future getPersonalInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        "/repairs/repairsUser/personalInfo", null);
    print(response.data.toString());
    setState(() {
      name = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['repairsUser']['name'];
      image = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['repairsUser']['headimg'];
    });
  }

  @override
  Widget build(BuildContext context) {
    PersonalViewMModel vm = PersonalViewMModel();
    List<PersonalModel> data = vm.getPersonalItems();
    deviceSize = MediaQuery.of(context).size;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.lightBlue,
        ),
        bottom: PreferredSize(
            child: Container(
              height: 100,
              child: FutureBuilder(builder: buildPersonalLine,future:getInfo),
            ),
            preferredSize: Size(30, 80)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
//                      buildPersonalLine(), //第一行
                ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildAddressLine(index, data);
                        }))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Copyright©2019-2029\n上海允宜实业发展有限公司",
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
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
        return new Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.only(left: 10, bottom: 10),
            height: 100,
            child: Center(
              child: ListTile(
                leading: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/alucard.jpg",
                    fit: BoxFit.fitWidth,
                    image: image,
                    width: 75.0,
                    height: 75.0,
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                      letterSpacing: 5, fontSize: 20, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (c) {
                        return null;
                      },
                    ),
                  ).then((_) {
                    getPersonalInfo();
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
                      return null;
                    },
                  ),
                )
                    : index == 1
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return null;
                    },
                  ),
                ): Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return null;
                    },
                  ),
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