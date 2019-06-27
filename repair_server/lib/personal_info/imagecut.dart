import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:repair_server/http_helper/HttpUtils.dart';
import 'package:repair_server/http_helper/api_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/http_helper/url_manager.dart';


class Imagecut extends StatefulWidget {

  final String id;
  final File imgurl;
  Imagecut({this.imgurl,this.id});
  
  @override
  ImagecutState createState() => ImagecutState();
}

class ImagecutState extends State<Imagecut> {
  File imageFile;
  String imageurl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageFile==null?imageurl=widget.imgurl.path:imageurl=imageFile.path;
   return Scaffold(
      appBar: AppBar(
        title: Text("裁剪头像"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          GestureDetector(
              onTap: (){
                ApiRequest().uploadHeadimg(context, imageurl, widget.id).then((result){
                  if(result){
                    Navigator.pop(context);
                  }
                });
              },
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '确定',
                    ),
                  )))
        ],
      ),
      body: Center(
        child: Image.file(File(imageurl)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _cropImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
      return Icon(Icons.crop);
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      maxWidth: 200,
      maxHeight: 200,
      sourcePath: widget.imgurl.path,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue,
      circleShape: true,
      toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
      print(imageFile.path);
    }
  }

}
