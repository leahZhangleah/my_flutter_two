class RepairsOrdersDescriptionList {
  String id;
  String repairsOrdersId;
  String url;
  int type;

  RepairsOrdersDescriptionList(
      {this.id, this.repairsOrdersId, this.url, this.type});

  RepairsOrdersDescriptionList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    repairsOrdersId = json['repairsOrdersId'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['repairsOrdersId'] = this.repairsOrdersId;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}

class RepairsOrdersQuote {
  String id;
  String repairsOrdersId;
  String maintainerUserId;
  double quoteMoney;
  double subscriptionRate;
  double subscriptionMoney;
  double balanceMoney;

  RepairsOrdersQuote(
      {this.id,
        this.repairsOrdersId,
        this.maintainerUserId,
        this.quoteMoney,
        this.subscriptionRate,
        this.subscriptionMoney,
        this.balanceMoney});

  RepairsOrdersQuote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    repairsOrdersId = json['repairsOrdersId'];
    maintainerUserId = json['maintainerUserId'];
    quoteMoney = json['quoteMoney'];
    subscriptionRate = json['subscriptionRate'];
    subscriptionMoney = json['subscriptionMoney'];
    balanceMoney = json['balanceMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['repairsOrdersId'] = this.repairsOrdersId;
    data['maintainerUserId'] = this.maintainerUserId;
    data['quoteMoney'] = this.quoteMoney;
    data['subscriptionRate'] = this.subscriptionRate;
    data['subscriptionMoney'] = this.subscriptionMoney;
    data['balanceMoney'] = this.balanceMoney;
    return data;
  }
}