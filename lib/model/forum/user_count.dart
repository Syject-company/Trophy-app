class UsersCount {
  final int usersCount;

  UsersCount({this.usersCount});

  factory UsersCount.fromJson(Map<String, dynamic> json) =>
      UsersCount(usersCount: json['participants'].length);
}
