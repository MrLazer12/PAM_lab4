import '../entities/banner.dart';

abstract class BannerRepository {
  Future<List<Banner>> getBanners();
}