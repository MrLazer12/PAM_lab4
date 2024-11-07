import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/repositories/clinic_repository.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  @override
  Future<List<Clinic>> getNearbyCenters() async {
    final String response = await rootBundle.loadString('assets/json/v1.json');
    final data = json.decode(response);
    return (data['nearby_centers'] as List)
        .map((item) => Clinic.fromJson(item))
        .toList();
  }
}
