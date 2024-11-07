import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab4/presentation/screens/home_screen.dart';

import 'data/repositories/banner_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/clinic_repository_impl.dart';
import 'data/repositories/doctor_repository_impl.dart';
import 'domain/usecases/get_banners.dart';
import 'domain/usecases/get_categories.dart';
import 'domain/usecases/get_doctors.dart';
import 'domain/usecases/get_nearby_centers.dart';

void main() {
  final bannerRepository = BannerRepositoryImpl();
  final categoryRepository = CategoryRepositoryImpl();
  final clinicRepository = ClinicRepositoryImpl();
  final doctorRepository = DoctorRepositoryImpl();

  runApp(DoctorFinderApp(
    getBanners: GetBanners(bannerRepository),
    getCategories: GetCategories(categoryRepository),
    getDoctors: GetDoctors(doctorRepository),
    getNearbyCenters: GetNearbyCenters(clinicRepository),
  ));
}

class DoctorFinderApp extends StatelessWidget {
  final GetBanners getBanners;
  final GetCategories getCategories;
  final GetDoctors getDoctors;
  final GetNearbyCenters getNearbyCenters;

  DoctorFinderApp({
    required this.getBanners,
    required this.getCategories,
    required this.getDoctors,
    required this.getNearbyCenters,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        getBanners: getBanners,
        getCategories: getCategories,
        getDoctors: getDoctors,
        getNearbyCenters: getNearbyCenters,
      ),
    );
  }
}
