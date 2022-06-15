import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:gotour_mobile/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Place>> _places;

  @override
  void initState() {
    super.initState();
    _places = fetchPlaces(1, "", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: const SearchBar(),
          elevation: 0,
          backgroundColor: Colors.grey[50],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: FutureBuilder<List<Place>>(
          future: _places,
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
