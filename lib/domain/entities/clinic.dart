class Clinic {
  final String image;
  final String title;
  final String locationName;
  final double reviewRate;
  final int countReviews;
  final double distanceKm;
  final int distanceMinutes;

  Clinic({
    required this.image,
    required this.title,
    required this.locationName,
    required this.reviewRate,
    required this.countReviews,
    required this.distanceKm,
    required this.distanceMinutes,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      image: json['image'] as String,
      title: json['title'] as String,
      locationName: json['location_name'] as String,
      reviewRate: json['review_rate'] as double,
      countReviews: json['count_reviews'] as int,
      distanceKm: json['distance_km'] as double,
      distanceMinutes: json['distance_minutes'] as int,
    );
  }
}
