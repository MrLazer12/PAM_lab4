class Banner {
  final String image;

  Banner({required this.image});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      image: json['image'] as String,
    );
  }
}
