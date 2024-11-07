import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  @override
  Future<List<Banner>> getBanners() async {
    final String response = await rootBundle.loadString('assets/json/v1.json');
    final data = json.decode(response);
    return (data['banners'] as List)
        .map((item) => Banner.fromJson(item))
        .toList();
  }
}
