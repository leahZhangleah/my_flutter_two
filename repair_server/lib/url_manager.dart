class UrlManager{
  String _baseUrl = "http://115.159.93.175:8281";
  String _captchSMS = "/captchaSMS";
  String _maintainerLogin = "/maintainer/login";
  String _receiveAppraiseList = "/repairs/repairsOrdersAppraise/receiveAppraiseList";
  String _maintainerList = "/repairs/repairsOrders/maintainerList";
  String _fileUploadServer = "https://tac-xiuyixiu-ho-1258818500.cos.ap-shanghai.myqcloud.com";
  String _quoteList = "/repairs/repairsOrders/quoteList";
  String _saveQuote = "/repairs/repairsOrdersQuote/save";
  String _captureOrder = "/repairs/repairsOrdersMaintainer/captureOrder/";
  String _finishMaintain= "/repairs/repairsOrders/successMaintainer/";
  String _personalInfo ="/maintainer/maintainerUser/personalInfo";
  String _logout="/maintainer/logout";
  String _myMaintainerUser =  "/maintainer/maintainerUser/myMaintainerUser";
  String _allotMaintainer = "/repairs/repairsOrdersMaintainer/allot/";
  String _uploadImg = "/upload/uploadImg";
  String _updatePersonalInfo =  "/maintainer/maintainerUser/update";
  String _cancelOrder =  "/repairs/repairsOrders/close/";

  String getUpdatePersonalInfoUrl(){
    return _getFullAddress(_updatePersonalInfo);
  }

  String getUploadImgUrl(){
    return _getFullAddress(_uploadImg);
  }

  String _getFullAddress(String prefix){
    return _baseUrl+prefix;
  }

  String getCaptchaSMS(){
    return _getFullAddress(_captchSMS);
  }

  String getMaintainerLogin(){
    return _getFullAddress(_maintainerLogin);
  }

  String get quoteList => _quoteList;

  String get baseUrl => _baseUrl;

  String get receiveAppraiseList => _receiveAppraiseList;

  String get maintainerList => _maintainerList;

  String get fileUploadServer => _fileUploadServer;

  String get saveQuote => _saveQuote;

  String get maintainerLogin => _maintainerLogin;

  String get captchSMS => _captchSMS;

  String get finishMaintain => _finishMaintain;

  String get captureOrder => _captureOrder;

  String get personalInfo => _personalInfo;

  String get logout => _logout;

  String get myMaintainerUser => _myMaintainerUser;

  String get allotMaintainer => _allotMaintainer;

  String get updatePersonalInfo => _updatePersonalInfo;

  String get uploadImg => _uploadImg;

  String get cancelOrder => _cancelOrder;


}