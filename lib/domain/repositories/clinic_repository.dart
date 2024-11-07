import '../entities/clinic.dart';

abstract class ClinicRepository {
  Future<List<Clinic>> getNearbyCenters();
}
