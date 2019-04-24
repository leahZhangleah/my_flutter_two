import 'order.dart';
class OrderResponse {
  String msg;
  int code;
  String fileUploadServer;
  bool state;
  Page page;

  OrderResponse(
      {this.msg, this.code, this.fileUploadServer, this.state, this.page});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    fileUploadServer = json['fileUploadServer'];
    state = json['state'];
    page = json['page'] != null ? new Page.fromJson(json['page']) : null;
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

class Page {
  int total;
  List<Order> rows;

  Page({this.total, this.rows});

  Page.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = new List<Order>();
      json['rows'].forEach((v) {
        rows.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}