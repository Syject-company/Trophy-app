class CategoryList {
  final List<Category> categoryList;

  CategoryList({this.categoryList});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List;
    List<Category> categoryList =
        categoriesJson.map((e) => Category.fromJson(e)).toList();
    return CategoryList(categoryList: categoryList);
  }

  factory CategoryList.filter(
      List<Category> category, List<int> subCategories, String cat) {
    List<Category> categoryFiltered = [];
    subCategories.forEach((element) {
      categoryFiltered
          .add(category[category.indexWhere((el) => el.id == element)]);
    });
    return CategoryList(categoryList: categoryFiltered);
  }
}

class Category {
  final int id;
  final String name;
  final String color;

  Category({this.id, this.name, this.color});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String);
}
