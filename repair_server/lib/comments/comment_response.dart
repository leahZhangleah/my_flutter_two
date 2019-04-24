import 'comment.dart';
class CommentResponse{
  String msg;
  int code;
  String fileUploadServer;
  bool state;
  Page page;

  CommentResponse({
    this.msg,
    this.code,
    this.fileUploadServer,
    this.state,
    this.page,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) => new CommentResponse(
    msg: json["msg"],
    code: json["code"],
    fileUploadServer: json["fileUploadServer"],
    state: json["state"],
    page: Page.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
    "fileUploadServer": fileUploadServer,
    "state": state,
    "page": page.toJson(),
  };
}

class Page {
  int total;
  List<Comment> comments;

  Page({
    this.total,
    this.comments,
  });

  factory Page.fromJson(Map<String, dynamic> json) => new Page(
    total: json["total"],
    comments: new List<Comment>.from(json["rows"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "rows": new List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}