class User {
  String _token;
  User(this._token);

  User.map(String token) {
    this._token = token;
  }

  String get token => _token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = _token;

    return map;
  }
}