class Trophy {
  Trophy(
      {this.totalPoints,
      this.id,
      this.serial,
      this.category,
      this.name,
      this.image,
      this.model,
      this.description,
      this.point,
      this.isVerified,
      this.howGet,
      this.setName});

  final String id;
  final String serial;
  final int category;
  final String name;
  final String image;
  final String model;
  final String description;
  final int point;
  final int totalPoints;
  final bool isVerified;
  final String setName;
  final String howGet;

  factory Trophy.fromFirebase(Map<String, dynamic> data) => Trophy(
      id: data['id'] as String,
      serial: data['serial'] as String,
      category: data['category'] as int,
      name: data['name'] as String,
      image: data['image'] as String,
      model: data['model'] as String,
      description: data['description'] as String,
      point: data['point'] as int,
      totalPoints: data['totalPoints'] as int,
      isVerified: data['isVerified'] as bool,
      setName: data['setName'] as String,
      howGet: data['howGet'] as String);
}
