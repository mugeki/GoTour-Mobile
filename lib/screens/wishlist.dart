import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:flutter/material.dart';

import '../services/places.dart';

class MyWishlist extends StatefulWidget {
  const MyWishlist({Key? key}) : super(key: key);

  @override
  State<MyWishlist> createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist> {
  late Future<List<Place>> _myWishlist;

  @override
  void initState() {
    super.initState();
    _myWishlist = fetchMyWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Colors.teal),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[50],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: FutureBuilder<List<Place>>(
          future: _myWishlist,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      child: PlaceCard(
                        id: snapshot.data![index].id,
                        isCarousel: false,
                        isMyPlace: false,
                        imgUrl: snapshot.data![index].imgUrl,
                        location: snapshot.data![index].location,
                        name: snapshot.data![index].name,
                        rating: double.parse(snapshot.data![index].rating),
                        ratingCount: snapshot.data![index].ratingCount,
                        isWishlisted: snapshot.data![index].isWishlisted,
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
