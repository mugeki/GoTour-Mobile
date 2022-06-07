import 'package:flutter/material.dart';
import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mockPlace = {
    "id": 1,
    "name": 'Tangkubah Perahu',
    "description": 'Bandung, West Java',
    "imgUrl":
        'https://gotour.vercel.app/_next/image?url=https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fgotour-27874.appspot.com%2Fo%2FIMG_12032020_142215__822_x_430_piksel_.jpg%3Falt%3Dmedia%26token%3Dbcb66b4c-92b6-4b95-9804-327063958cd8&w=640&q=75',
    "rating": 4.0,
    "ratingCount": 120,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Most Rated',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          CarouselSlider(
            options: CarouselOptions(height: 310),
            items: [
              PlaceCard(
                id: mockPlace['id'] as double,
                isCarousel: true,
                isMyPlace: false,
                imgUrl: mockPlace['imgUrl'].toString(),
                description: mockPlace['description'].toString(),
                name: mockPlace['name'].toString(),
                rating: mockPlace['rating'] as double,
                ratingCount: mockPlace['ratingCount'] as double,
              ),
              PlaceCard(
                id: mockPlace['id'] as double,
                isCarousel: true,
                isMyPlace: false,
                imgUrl: mockPlace['imgUrl'].toString(),
                description: mockPlace['description'].toString(),
                name: mockPlace['name'].toString(),
                rating: mockPlace['rating'] as double,
                ratingCount: mockPlace['ratingCount'] as double,
              ),
              PlaceCard(
                id: mockPlace['id'] as double,
                isCarousel: true,
                isMyPlace: false,
                imgUrl: mockPlace['imgUrl'].toString(),
                description: mockPlace['description'].toString(),
                name: mockPlace['name'].toString(),
                rating: mockPlace['rating'] as double,
                ratingCount: mockPlace['ratingCount'] as double,
              )
            ],
          ),
          const Text(
            'Recently Added',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          PlaceCard(
            id: mockPlace['id'] as double,
            isCarousel: false,
            isMyPlace: true,
            imgUrl: mockPlace['imgUrl'].toString(),
            description: mockPlace['description'].toString(),
            name: mockPlace['name'].toString(),
            rating: mockPlace['rating'] as double,
            ratingCount: mockPlace['ratingCount'] as double,
          ),
        ],
      ),
    );
  }
}
