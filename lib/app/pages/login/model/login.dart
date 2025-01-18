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
  final int exp;

  LoginResponse({
    required this.token, 
    required this.user,
    required this.exp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'] as String? ?? '',
    user: UserInfo.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    exp: json['exp'] as int? ?? 0,
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
    this.id = 0,
    this.nickname = '',
    this.avatar = '',
    this.sex = 0,
    this.email = '',
    this.phone = '',
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json['id'] as int? ?? 0,
    nickname: json['nickname'] as String? ?? '',
    avatar: json['avatar'] as String? ?? '',
    sex: json['sex'] as int? ?? 0,
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
  );
}