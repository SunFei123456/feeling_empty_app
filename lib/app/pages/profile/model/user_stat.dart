class UserStat {
   int bottles;
   int follows;
   int followers;

  UserStat({
    this.bottles = 0,
    this.follows = 0,
    this.followers = 0,
  });

  factory UserStat.fromJson(Map<String, dynamic> json) {
    return UserStat(
      bottles: json['bottles'] as int? ?? 0,
      follows: json['follows'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
    );
  }
} 