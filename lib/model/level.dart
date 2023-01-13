class Level {
  Level({
    this.id,
    this.name,
    this.point,
    this.image,
  });

  final int id;
  final String name;
  final int point;
  final String image;

  factory Level.fromFirebase(Map<String, dynamic> data) {
    return Level(
      id: data['id'] as int,
      name: data['name'] as String,
      point: data['point'] as int,
      image: data['image'] as String,
    );
  }

  Map<String, dynamic> toFirebase() => {
        'id': this.id,
        'name': this.name,
        'point': this.point,
        'image': this.image,
      };
}
