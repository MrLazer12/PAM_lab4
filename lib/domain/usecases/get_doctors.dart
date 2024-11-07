import '../entities/doctor.dart';
import '../repositories/doctor_repository.dart';

class GetDoctors {
  final DoctorRepository repository;

  GetDoctors(this.repository);

  Future<List<Doctor>> execute() async {
    return await repository.getDoctors();
  }
}