class User {
  late int? userid;
  late String? username;
  late String? password;
  User({this.userid, this.username, this.password});
  User.fromMap(dynamic obj) {
    this.userid = obj['userid'];
    this.username = obj['username'];
    this.password = obj['password'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'password': password,
    };
    return map;
  }
}