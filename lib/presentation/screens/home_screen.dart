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

  HomeScreen({
    required this.getBanners,
    required this.getCategories,
    required this.getDoctors,
    required this.getNearbyCenters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Finder"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Banners Section
              _BannerSlider(getBanners: getBanners),
              SizedBox(height: 20),

              // Categories Section
              SectionTitle(title: 'Categories'),
              FutureBuilder<List<Category>>(
                future: getCategories.execute(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final categories = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                categories[index].icon,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(
                                categories[index].title,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No categories available'));
                  }
                },
              ),
              SizedBox(height: 20),

              // Nearby Clinics Section
              SectionTitle(title: 'Nearby Clinics'),
              FutureBuilder<List<Clinic>>(
                future: getNearbyCenters.execute(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final clinics = snapshot.data!;
                    return Column(
                      children: clinics.map((clinic) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(clinic.image, width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            title: Text(clinic.title, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(clinic.locationName),
                                Text('Distance: ${clinic.distanceKm} km'),
                                Text('Reviews: ${clinic.countReviews} (Rating: ${clinic.reviewRate})'),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text('No nearby clinics available'));
                  }
                },
              ),
              SizedBox(height: 20),

              // Doctors Section
              SectionTitle(title: 'Doctors'),
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
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(doctor.image),
                              radius: 30,
                            ),
                            title: Text(doctor.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Specialty: ${doctor.typeOfDoctor}'),
                                Text('Location: ${doctor.locationOfCenter}'),
                                Text('Reviews: ${doctor.reviewsCount} (Rating: ${doctor.reviewRate})'),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text('No doctors available'));
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
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Doctors or Clinics...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 16),
              // Banner Image Slider
              Container(
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
          return Center(child: Text('No banners available'));
        }
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
