class ReviewModel {
  String? review;
  double rating;
  String userId;
  DateTime date;

  ReviewModel({
    this.review,
    required this.userId,
    required this.rating,
    required this.date,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        review: map['review'],
        userId: map['userId'],
        rating: map['rating'],
        date: DateTime.tryParse(map['date'])!,
      );

  Map<String, dynamic> toMap() => {
        "review": review,
        "userId": userId,
        "rating": rating,
        "date": date.toIso8601String(),
      };
}
