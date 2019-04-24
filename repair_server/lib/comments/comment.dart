class Comment {
  String id;
  String ordersId;
  String ordersNumber;
  String ordersDescription;
  String ordersType;
  String content;
  int starLevel;
  String createUserId;
  String createUserName;
  String createUserHeadimg;
  String createTime;
  String updateTime;

  Comment({
    this.id,
    this.ordersId,
    this.ordersNumber,
    this.ordersDescription,
    this.ordersType,
    this.content,
    this.starLevel,
    this.createUserId,
    this.createUserName,
    this.createUserHeadimg,
    this.createTime,
    this.updateTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
    id: json["id"],
    ordersId: json["ordersId"],
    ordersNumber: json["ordersNumber"],
    ordersDescription: json["ordersDescription"],
    ordersType: json["ordersType"],
    content: json["content"],
    starLevel: json["starLevel"],
    createUserId: json["createUserId"],
    createUserName: json["createUserName"],
    createUserHeadimg: json["createUserHeadimg"],
    createTime: json["createTime"],
    updateTime: json["updateTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ordersId": ordersId,
    "ordersNumber": ordersNumber,
    "ordersDescription": ordersDescription,
    "ordersType": ordersType,
    "content": content,
    "starLevel": starLevel,
    "createUserId": createUserId,
    "createUserName": createUserName,
    "createUserHeadimg": createUserHeadimg,
    "createTime": createTime,
    "updateTime": updateTime,
  };
}