import 'package:repair_server/order/page.dart';

import 'order.dart';
class OrderResponse {
  String msg;
  int code;
  String fileUploadServer;
  bool state;
  OrderPage page;

  OrderResponse(
      {this.msg, this.code, this.fileUploadServer, this.state, this.page});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    fileUploadServer = json['fileUploadServer'];
    state = json['state'];
    page = json['page'] != null ? new OrderPage.fromJson(json['page']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['fileUploadServer'] = this.fileUploadServer;
    data['state'] = this.state;
    if (this.page != null) {
      data['page'] = this.page.toJson();
    }
    return data;
  }
}

