import 'package:flutter/material.dart';
import 'package:repair_server/HttpUtils.dart';
import 'package:repair_server/model/bottom_button.dart';
import 'package:repair_server/model/staff.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseMaintainer extends StatefulWidget {
  final String orderId;

  ChooseMaintainer({this.orderId});

  ChooseMaintainerState createState() => ChooseMaintainerState();
}

class ChooseMaintainerState extends State<ChooseMaintainer> {
  List<Staff> staffList = [];
  var getStaff;
  List<bool> ischecks = [];

  @override
  void initState() {
    getStaff = staff();
    super.initState();
  }

  Future staff() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        "/maintainer/maintainerUser/myMaintainerUser", null);
    print(response.data.toString());
    setState(() {
      staffList = Staff.allFromResponse(response.data.toString());
    });
  }

  //分配订单
  Future allotOrder(String ordersId) async {
    List<String> userIds = [];
    for(int i = 0;i<staffList.length;i++){
      if(ischecks[i]){
        userIds.add(staffList[i].id);
      }
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        "/repairs/repairsOrdersMaintainer/allot/$ordersId",userIds);
    print(response.data.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("选择维修员"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                ischecks = List.generate(staffList.length, (int index) {
                  return true;
                });
              },
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  '全选',
                ),
              )))
        ],
      ),
      body: FutureBuilder(
        builder: _buildFuture,
        future: getStaff,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: RaisedButton(
            onPressed: () => allotOrder(widget.orderId),
            child: Text(
              "确定",
              style: TextStyle(fontSize: 20),
            ),
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
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
        for (int i = 0; i < staffList.length; i++) {
          ischecks.add(false);
        }
        return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              var sL = staffList[index];
              return ListTile(
                title: Text(sL.name),
                trailing: Checkbox(
                  value: ischecks[index],
                  onChanged: (bool val) {
                    setState(() {
                      ischecks[index] = val;
                    });
                  },
                ),
              );
            });
    }
  }
}
