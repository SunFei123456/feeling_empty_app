// 登录请求参数模型
class LoginModel {
  final String account;
  final String password;

  LoginModel({required this.account, required this.password});

  Map<String, dynamic> toJson() => {
    'account': account,
    'password': password,
  };

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    account: json['account'] as String,
    password: json['password'] as String,
  );
}

// 登录成功之后的响应模型
class LoginResponse {
  final String token;
  final UserInfo user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'] as String,
    user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
  );
}

// 用户信息模型
class UserInfo {
  final int id;
  final String nickname;
  final String avatar;
  final int sex;
  final String email;
  final String phone;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.sex,
    required this.email,
    required this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json['id'] as int,
    nickname: json['nickname'] as String,
    avatar: json['avatar'] as String,
    sex: json['sex'] as int,
    email: json['email'] as String,
    phone: json['phone'] as String,
  );
}