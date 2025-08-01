import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Predefined banner data to match the screenshot
    final List<String> bannerData = [
      'assets/sliders/s1.png',
      'assets/sliders/s2.png',
      'assets/sliders/s3.png',
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerData.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                child: Image.asset(
                  bannerData[index],
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .1,
                ),
              ),
            );
          },
          options: CarouselOptions(
            //   height: 140.0, // Height adjusted to match screenshot
            height: MediaQuery.of(context).size.height * .2,
            autoPlay: true,
            enlargeCenterPage: false, // Changed to false to match screenshot
            initialPage: 0, // Ensure starting with first banner
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.99,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator dots - styled to match the screenshot
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerData.length,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? const Color(
                        0xFF6200EE) // Purple color for active dot as in screenshot
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
