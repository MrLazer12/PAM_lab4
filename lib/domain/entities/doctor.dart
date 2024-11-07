class Doctor {
  final String image;
  final String fullName;
  final String typeOfDoctor;
  final String locationOfCenter;
  final double reviewRate;
  final int reviewsCount;

  Doctor({
    required this.image,
    required this.fullName,
    required this.typeOfDoctor,
    required this.locationOfCenter,
    required this.reviewRate,
    required this.reviewsCount,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      image: json['image'] as String,
      fullName: json['full_name'] as String,
      typeOfDoctor: json['type_of_doctor'] as String,
      locationOfCenter: json['location_of_center'] as String,
      reviewRate: json['review_rate'] as double,
      reviewsCount: json['reviews_count'] as int,
    );
  }
}
