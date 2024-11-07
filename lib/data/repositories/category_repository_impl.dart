import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<List<Category>> getCategories() async {
    final String response = await rootBundle.loadString('assets/json/v1.json');
    final data = json.decode(response);
    return (data['categories'] as List)
        .map((item) => Category.fromJson(item))
        .toList();
  }
}
