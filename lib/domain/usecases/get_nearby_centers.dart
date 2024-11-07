import '../entities/clinic.dart';
import '../repositories/clinic_repository.dart';

class GetNearbyCenters {
  final ClinicRepository repository;

  GetNearbyCenters(this.repository);

  Future<List<Clinic>> execute() async {
    return await repository.getNearbyCenters();
  }
}