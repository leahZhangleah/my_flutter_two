class UrlManager{
  String _baseUrl = "http://192.168.11.114:8281";
  String _receiveAppraiseList = "/repairs/repairsOrdersAppraise/receiveAppraiseList";
  String _maintainerList = "/repairs/repairsOrders/maintainerList";
  String _fileUploadServer = "https://tac-xiuyixiu-ho-1258818500.cos.ap-shanghai.myqcloud.com";

  String get baseUrl => _baseUrl;

  String get receiveAppraiseList => _receiveAppraiseList;

  String get maintainerList => _maintainerList;

  String get fileUploadServer => _fileUploadServer;


}