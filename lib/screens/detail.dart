import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/places.dart';
import '../widgets/wishlist_btn.dart';

class Detail extends StatefulWidget {
  const Detail({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<Place> _place;

  @override
  void initState() {
    super.initState();
    _place = fetchPlace(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Place>(
            future: _place,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(viewportFraction: 1.0),
                      items: (snapshot.data!.imgUrl as List)
                          .map((img) => Center(
                                  child: Image.network(
                                img,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )))
                          .toList(),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RatingBar(
                                initialRating:
                                    double.parse(snapshot.data!.rating),
                                ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star_rounded,
                                        color: Colors.amber),
                                    half: const Icon(Icons.star_half_rounded,
                                        color: Colors.amber),
                                    empty: const Icon(Icons.star_border_rounded,
                                        color: Colors.amber)),
                                itemCount: 5,
                                itemSize: 20.0,
                                minRating: 1,
                                onRatingUpdate: (rating) async {
                                  final response = await putRatePlace(
                                      widget.id, rating.toInt());
                                  const snackBar = SnackBar(
                                    content: Text('Place has been rated!'),
                                  );

                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              ),
                              Text(
                                  '(${snapshot.data!.ratingCount.toString()})'),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: WishlistBtn(
                                        id: widget.id,
                                        isWishlishted:
                                            snapshot.data!.isWishlisted)),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(snapshot.data!.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(snapshot.data!.location,
                                style: const TextStyle(fontSize: 18)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(snapshot.data!.description,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
