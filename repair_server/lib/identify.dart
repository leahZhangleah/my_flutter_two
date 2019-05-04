import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:repair_server/identifyName.dart';

class Identify extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IdentifyState();
  }
}

class IdentifyState extends State<Identify> {
  num paddingHorizontal = 20.0;

  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("认证信息"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 70,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "添加人",
                        style: TextStyle(color: Colors.grey[350], fontSize: 18),
                      ),
                      GestureDetector(
                          onTap: ()=>Navigator.push<String>(
                              context,new MaterialPageRoute(builder: (BuildContext context){
                            return new IdentifyName(name:"",id:"");
                          })
                          ).then((res) {}),
                          child: Text("", style: TextStyle(fontSize: 20),))
                    ],
                  ),
                )),
            Container(
                height: 70,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "证件号码",
                        style: TextStyle(color: Colors.grey[350], fontSize: 18),
                      ),
                      GestureDetector(
                          onTap: ()=>Navigator.push<String>(
                              context,new MaterialPageRoute(builder: (BuildContext context){
                            return new IdentifyName(name:"",id:"");
                          })
                          ).then((res){
                          }),
                          child: Text("", style: TextStyle(fontSize: 20),))
                    ],
                  ),
                ))
          ],
        ),
      )
    );
  }
}
