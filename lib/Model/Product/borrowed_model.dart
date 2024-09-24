class BorrowedModel {
  int id;
  String username;
  String pathBook;
  String coverImage;
  String description;
  String title;
  String subtitle;
  String returnDate;
  double avarageRating;
  String company;

  BorrowedModel(
      {required this.subtitle,
      required this.description,
      required this.title,
      required this.coverImage,
      required this.id,
      required this.pathBook,
      required this.returnDate,
      required this.avarageRating,
      required this.username,
      required this.company});

  factory BorrowedModel.fromJson(Map<String, dynamic> json) {
    return BorrowedModel(
        subtitle: json["subtite"],
        description: json["description"],
        title: json["title"],
        coverImage: json["coverImage"],
        id: json["id"],
        pathBook: json["pathBook"],
        returnDate: json["returnDate"],
        avarageRating: json["averageRate"],
        username: json["username"],
        company: json["company"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "subtitle": subtitle,
      "coverImage": coverImage,
      "pathBook": pathBook,
      "id": id,
      "returnDate": returnDate,
      "averageRate": avarageRating,
      "username": username,
      "company": company
    };
  }
}
