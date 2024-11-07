import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/usecases/get_banners.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_doctors.dart';
import '../../domain/usecases/get_nearby_centers.dart';
import '../../domain/entities/banner.dart' as custom_banner;

class HomeScreen extends StatelessWidget {
  final GetBanners getBanners;
  final GetCategories getCategories;
  final GetDoctors getDoctors;
  final GetNearbyCenters getNearbyCenters;

  const HomeScreen({super.key,
    required this.getBanners,
    required this.getCategories,
    required this.getDoctors,
    required this.getNearbyCenters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Finder", style: TextStyle(fontSize: 24, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Banners Section
              _BannerSlider(getBanners: getBanners),
              const SizedBox(height: 20),

              // Categories Section
              const SectionTitle(title: 'Categories'),
              FutureBuilder<List<Category>>(
                future: getCategories.execute(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final categories = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0, // No shadow
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                categories[index].icon,
                                width: 75,
                                height: 75,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                categories[index].title,
                                style: const TextStyle(fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No categories available'));
                  }
                },
              ),
              const SizedBox(height: 25),

              // Nearby Clinics Section (Slider)
              const SectionTitle(title: 'Nearby Clinics'),
              _NearbyClinicsSlider(getNearbyCenters: getNearbyCenters),
              const SizedBox(height: 24),

              // Doctors Section
              const SectionTitle(title: 'Doctors'),
              FutureBuilder<List<Doctor>>(
                future: getDoctors.execute(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final doctors = snapshot.data!;
                    return Column(
                      children: doctors.map((doctor) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(doctor.image, width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  doctor.fullName,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite_border, size: 24, color: Colors.red),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Specialty: ${doctor.typeOfDoctor}', style: TextStyle(fontSize: 16, color: Colors.black)),
                                Text('Location: ${doctor.locationOfCenter}', style: TextStyle(fontSize: 16, color: Colors.black)),
                                Text('Reviews: ${doctor.reviewsCount} (Rating: ${doctor.reviewRate})', style: TextStyle(fontSize: 16, color: Colors.black)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(child: Text('No doctors available'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerSlider extends StatefulWidget {
  final GetBanners getBanners;

  const _BannerSlider({required this.getBanners});

  @override
  __BannerSliderState createState() => __BannerSliderState();
}

class __BannerSliderState extends State<_BannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<custom_banner.Banner>>(
      future: widget.getBanners.execute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final banners = snapshot.data!;
          return Column(
            children: [
              // Search input field
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Doctors or Clinics...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              // Banner Image Slider
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: banners.length,
                  controller: PageController(initialPage: _currentIndex),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(banners[index].image, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                      (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentIndex == index ? 15 : 10,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No banners available'));
        }
      },
    );
  }
}

class _NearbyClinicsSlider extends StatefulWidget {
  final GetNearbyCenters getNearbyCenters;

  const _NearbyClinicsSlider({required this.getNearbyCenters});

  @override
  __NearbyClinicsSliderState createState() => __NearbyClinicsSliderState();
}

class __NearbyClinicsSliderState extends State<_NearbyClinicsSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Clinic>>(
      future: widget.getNearbyCenters.execute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final clinics = snapshot.data!;
          return SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: clinics.length,
              controller: PageController(initialPage: _currentIndex),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Clinic image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          clinics[index].image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 140,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          clinics[index].title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          clinics[index].locationName,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              '${clinics[index].reviewRate} (${clinics[index].countReviews} reviews)',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              '${clinics[index].distanceKm} km (${clinics[index].distanceMinutes} min)',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No nearby clinics available'));
        }
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
