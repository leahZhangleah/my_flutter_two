import 'package:repair_server/comments/page.dart';

import 'comment.dart';
class CommentResponse{
  String msg;
  int code;
  String fileUploadServer;
  bool state;
  CommentPage page;

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
    page: CommentPage.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
    "fileUploadServer": fileUploadServer,
    "state": state,
    "page": page.toJson(),
  };
}

