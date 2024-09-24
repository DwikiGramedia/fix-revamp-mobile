import 'category_model.dart';

class Categories {
  List<CategoryModel> categories;
  Categories({required this.categories});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        categories: json["categories"]
            .map<CategoryModel>((model) => CategoryModel.fromJson(model))
            .toList());
  }

  Map<String,dynamic> toJson(){
    return {
      'categories': categories.map((e) => e.toJson()).toList()
    };
  }
}