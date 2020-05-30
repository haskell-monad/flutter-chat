class MatrixClient {

  String homeServer;
  String clientName;

  int id;

  String accessToken;
  String userId;
  String avatar;

  String deviceId;
  String deviceName;

  bool debug;

  MatrixClient(
      this.clientName, {
        this.debug = false,
      });

  /// 返回当前登录状态.
  bool isLogged() => accessToken != null;

  MatrixClient.fromJson(Map<String, dynamic> json){
    homeServer = json['homeServer'];
    clientName = json['clientName'];
    id = json['id'];
    accessToken = json['accessToken'];
    userId = json['userId'];
    avatar = json['avatar'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    debug = json['debug'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeServer'] = this.homeServer;
    data['clientName'] = this.clientName;
    data['id'] = this.id;
    data['accessToken'] = this.accessToken;
    data['userId'] = this.userId;
    data['avatar'] = this.avatar;
    data['deviceId'] = this.deviceId;
    data['deviceName'] = this.deviceName;
    data['debug'] = this.debug;
    return data;
  }
}