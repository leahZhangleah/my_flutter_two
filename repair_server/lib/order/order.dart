import 'repairs_orders_description.dart';
class Order {
  String id;
  String orderNumber;
  String description;
  String type;
  int orderState;
  String contactsName;
  String contactsPhone;
  String contactsAddress;
  String createUserId;
  String createTime;
  String updateTime;
  int status;
  List<RepairsOrdersDescriptionList> repairsOrdersDescriptionList;
  RepairsOrdersQuote repairsOrdersQuote;

  Order(
      {this.id,
        this.orderNumber,
        this.description,
        this.type,
        this.orderState,
        this.contactsName,
        this.contactsPhone,
        this.contactsAddress,
        this.createUserId,
        this.createTime,
        this.updateTime,
        this.status,
        this.repairsOrdersDescriptionList,
        this.repairsOrdersQuote});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    description = json['description'];
    type = json['type'];
    orderState = json['orderState'];
    contactsName = json['contactsName'];
    contactsPhone = json['contactsPhone'];
    contactsAddress = json['contactsAddress'];
    createUserId = json['createUserId'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    if (json['repairsOrdersDescriptionList'] != null) {
      repairsOrdersDescriptionList = new List<RepairsOrdersDescriptionList>();
      json['repairsOrdersDescriptionList'].forEach((v) {
        repairsOrdersDescriptionList
            .add(new RepairsOrdersDescriptionList.fromJson(v));
      });
    }
    repairsOrdersQuote = json['repairsOrdersQuote'] != null
        ? new RepairsOrdersQuote.fromJson(json['repairsOrdersQuote'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['description'] = this.description;
    data['type'] = this.type;
    data['orderState'] = this.orderState;
    data['contactsName'] = this.contactsName;
    data['contactsPhone'] = this.contactsPhone;
    data['contactsAddress'] = this.contactsAddress;
    data['createUserId'] = this.createUserId;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    if (this.repairsOrdersDescriptionList != null) {
      data['repairsOrdersDescriptionList'] =
          this.repairsOrdersDescriptionList.map((v) => v.toJson()).toList();
    }
    if (this.repairsOrdersQuote != null) {
      data['repairsOrdersQuote'] = this.repairsOrdersQuote.toJson();
    }
    return data;
  }
}