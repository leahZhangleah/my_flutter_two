import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:repair_server/MainPage.dart';
import 'package:repair_server/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_server/comments/received_comments.dart';

String account, password;
enum Actions{Increase}

Future<void> main() async {//入口
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new Rooter());
}

class Rooter extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<Rooter> with SingleTickerProviderStateMixin {

  final routes = <String, WidgetBuilder>{
    "/home": (context) => MainPage(), //主页//欢迎
    "/register": (context) => RegisterScreen(), //注册
    "/comments":(context)=>ReceivedComments(),
  };

  String token,type = "";

  @override
  void initState() {
    super.initState();
  }

  Future<String> getToken() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token");
      type = sp.getString("type");
    });
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      routes: routes,
      home: token==null?RegisterScreen():MainPage(),
    );
  }
}
