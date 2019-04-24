class UrlManager{
  String _baseUrl = "http://192.168.11.114:8281";
  String _receiveAppraiseList = "/repairs/repairsOrdersAppraise/receiveAppraiseList";
  String _maintainerList = "/repairs/repairsOrders/maintainerList";

  String get receiveAppraiseList => _receiveAppraiseList;

  String get maintainerList => _maintainerList;


}