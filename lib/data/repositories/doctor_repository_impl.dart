import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  @override
  Future<List<Doctor>> getDoctors() async {
    final String response = await rootBundle.loadString('assets/json/v1.json');
    final data = json.decode(response);
    return (data['doctors'] as List)
        .map((item) => Doctor.fromJson(item))
        .toList();
  }
}
