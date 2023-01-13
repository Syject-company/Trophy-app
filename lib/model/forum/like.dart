class Like {
  int id;
  int count;
  bool acted;

  Like({this.id, this.count, this.acted});

  factory Like.fromJson(Map<String, dynamic> json) {
    int id;
    int count;
    bool acted;
    id = json['id'];
    count = json['count'] ?? 0;
    acted = json['acted'] ?? false;
    return Like(id: id, count: count, acted: acted);
  }
}
