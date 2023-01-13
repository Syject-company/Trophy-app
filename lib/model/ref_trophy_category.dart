class TrophyCategory {
  final int id;
  final String icon;
  final String name;

  TrophyCategory({
    this.id,
    this.icon,
    this.name,
  });

  factory TrophyCategory.fromFirebase(Map<String, dynamic> data) {
    return TrophyCategory(
      id: data['id'] as int,
      icon: data['icon'] as String,
      name: data['name'] as String,
    );
  }

  Map<String, dynamic> toFirebase() => {
        'id': this.id,
        'icon': icon,
        'name': this.name,
      };
}
