import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_server/HttpUtils.dart';
import 'Name.dart';
import 'package:repair_server/personal_info/imagecut.dart';
import 'package:repair_server/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repair_server/url_manager.dart';

class Personal extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersonalState();
  }
}

class PersonalState extends State<Personal> {
  num paddingHorizontal = 20.0;
  String name,id,_res,url="";
  String imageUrl = "assets/images/person_placeholder.png"; //initial placeholder image
  var getInfo;
  bool isVideo = false;

  Future<File> _imageFile;

  void initState(){
    super.initState();
    getInfo =  getPersonalInfo();
  }



  void _onImageButtonPressed(ImageSource source) async{
    setState(() {
      if (isVideo) {
        return;
      } else {
         _imageFile = ImagePicker.pickImage(source: source).then((_){
           if(_==null){
             Navigator.pop(context);
             return;
           }
          // uploadHeadimg();
           imageUrl = _.path;
          updatePersonHeading(_);
        });
      }
    });
  }

  Future updatePersonHeading(File file) async{
//    print(imageUrl);
//    print(imageUrl.substring(7,imageUrl.length-1));
//    imageUrl = imageUrl.substring(7,imageUrl.length-1);
    Navigator.push<String>(
        context,new MaterialPageRoute(builder: (BuildContext context){
      return new Imagecut(imgurl:file,id:id);
    })
    ).then((_){
      Navigator.pop(context);
    });
  }


  Future getPersonalInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        UrlManager().personalInfo,null);
    print(response.data.toString());
    setState(() {
      name = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['maintainerUser']['name'];
      id = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['maintainerUser']['id'];
      imageUrl = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['maintainerUser']['headimg'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
    centerTitle: true,
    leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
    ),
      body: FutureBuilder(
        builder: _buildFuture,
        future: getInfo, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
      ),
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Center(child:Text('还没有开始网络请求'));
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "头像",
                    style: TextStyle(color: Colors.grey[350], fontSize: 18),
                  ),
                  RaisedButton(
                    shape: CircleBorder(),
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                leading: new Icon(Icons.photo_camera),
                                title: new Text("拍照"),
                                onTap: ()=>_onImageButtonPressed(ImageSource.camera)
                              ),
                              new ListTile(
                                leading: new Icon(Icons.photo_library),
                                title: new Text("手机相册上传"),
                                onTap: ()=>_onImageButtonPressed(ImageSource.gallery)
                              ),
                            ],
                          );
                        }).then((_){
                          getPersonalInfo();
                    }),
                    child: ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 75.0,
                        height: 75.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
              height: 70,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "昵称",
                      style: TextStyle(color: Colors.grey[350], fontSize: 18),
                    ),
                    GestureDetector(
                        onTap: ()=>Navigator.push<String>(
                            context,new MaterialPageRoute(builder: (BuildContext context){
                          return new Name(name:name,id:id);
                        })
                        ).then((res){
                          _res=res;
                          name=_res;
                        }),
                        child: Text(name, style: TextStyle(fontSize: 20),))
                  ],
                ),
              ))
        ],
      ),
    );
      default:
        Fluttertoast.showToast(msg: "请检查网络连接状态！");
    }
}



}
