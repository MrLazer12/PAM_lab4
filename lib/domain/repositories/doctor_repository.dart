import '../entities/doctor.dart';

abstract class DoctorRepository {
  Future<List<Doctor>> getDoctors();
}