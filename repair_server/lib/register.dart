import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:repair_server/RegisterResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  String _phone, _capcha;

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final String baseUrl = "http://115.159.93.175:8281";
  bool _isAllowCapcha = true;
  String hintText = "获取验证码";
  String unit = "秒";
  num lastTime = 60;
  String tempStr;
  TimerUtil timer;
  Dio dio;

  @override
  void initState() {
    super.initState();
    tempStr = hintText;
    timer = TimerUtil(mInterval: 1000, mTotalTime: 6000);
    Options option = Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        baseUrl: baseUrl);
    dio = new Dio(option);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("登录"),
          centerTitle: true,
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            //隐藏键盘,
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  children: <Widget>[
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    buildTitle(),
                    SizedBox(height: 70.0),
                    buildAccountTextField(),
                    SizedBox(height: 30.0),
                    buildCapchaTextField(context),
                    SizedBox(height: 60.0),
                    buildLoginButton(context),
                    SizedBox(height: 30.0),
                  ],
                ))));
  }

  Padding buildTitle() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            '登录',
            style: TextStyle(
                fontSize: 42.0,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid),
          ),
        ));
  }

  Widget buildCapchaTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => widget._capcha = value,
      decoration: InputDecoration(
          labelText: '验证码',
          suffixIcon: FlatButton(
              color: Colors.blue,
              child: Text(tempStr, style: TextStyle(fontSize: 12)),
              disabledTextColor: Colors.white,
              disabledColor: Colors.grey,
              textColor: Colors.white,
              onPressed: _isAllowCapcha ? _getCapcha : null)),
    );
  }

  void updateButtonState() {
    timer = TimerUtil(mInterval: 1000, mTotalTime: 6000);
    timer.setOnTimerTickCallback(updateTimer);
    timer.startCountDown();
  }

  void updateTimer(finish) {
    setState(() {
      tempStr = (finish / 1000).toString().replaceAll(".0", "") + unit;
      if (finish == 0) {
        tempStr = hintText;
        _isAllowCapcha = !_isAllowCapcha;
      }
    });
  }

  TextFormField buildAccountTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '手机号:',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}\$");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的手机号码';
        }
      },
      initialValue: widget._phone,
      onSaved: (String value) => widget._phone = value,
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue[400],
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              _login();
            }
          },
          shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }

  Future _getCapcha() async {
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();
    } else {
      return;
    }
    RegisterResponse result;
    Response res = await dio.get("http://115.159.93.175:8281/captchaSMS",
        data: {"phone": widget._phone});
    if (res.statusCode == 200) {
      result = RegisterResponse.fromJson(res.data);
    }
    if (result.state) {
      setState(() {
        _isAllowCapcha = !_isAllowCapcha;
      });
      updateButtonState();
    }
  }

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget._phone.isEmpty || widget._capcha.isEmpty) {
      setState(() {
        showDialog(
            context: context,
            child: AlertDialog(content: Text("用户名和验证码不能为空"), actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("确定"),
              )
            ]));
      });
      return;
    }
    Response response = await dio.post("$baseUrl/maintainer/login",
        data: {"phone": widget._phone, "captcha": widget._capcha});
    print(response);
    if (response.statusCode == 200 && response.data["code"] != 500) {
      prefs.setString("token", response.data["token"]);
      prefs.setString("type", response.data["type"].toString());
      prefs.setString("account", widget._phone);
      Navigator.of(context).pushReplacementNamed("/home");
    }
  }
}
