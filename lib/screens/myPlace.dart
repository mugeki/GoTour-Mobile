import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:flutter/material.dart';

class MyPlaces extends StatefulWidget {
  const MyPlaces({Key? key}) : super(key: key);

  @override
  State<MyPlaces> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyPlaces> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Places",
                    style: TextStyle(color: Color(0xff499E8F), fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_box_outlined,
                        color: Color(0xff499E8F),
                      ))
                ],
              ),
            ),
            FutureBuilder(builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: (snapshot.data as List)
                        .take(4)
                        .map(
                          (place) => PlaceCard(
                            id: place.id,
                            isCarousel: true,
                            isMyPlace: false,
                            imgUrl: place.imgUrl,
                            location: place.location,
                            name: place.name,
                            rating: double.parse(place.rating),
                            ratingCount: place.ratingCount,
                            isWishlisted: place.isWishlisted,
                          ),
                        )
                        .toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            })
          ],
        ),
      ),
    );
  }
}
