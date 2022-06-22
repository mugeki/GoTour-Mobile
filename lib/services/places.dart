import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Place>> fetchPlaces(
  double page,
  String keyword,
  String sortBy,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');

  final placeResponse = await http.get(Uri.parse(
      "${dotenv.env['BE_API_URL']}/place?page=$page&keyword=$keyword&sort_by=$sortBy"));
  final wishlistResponse = await http
      .get(Uri.parse("${dotenv.env['BE_API_URL']}/wishlist"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });

  dynamic placeResponseDecoded = jsonDecode(placeResponse.body);
  dynamic wishlistResponseDecoded = jsonDecode(wishlistResponse.body);

  placeResponseDecoded['data']['data'].forEach((place) => {
        place['is_wishlisted'] = wishlistResponseDecoded['data']
            .any((wishlist) => wishlist['id'] == place['id'])
      });

  if (placeResponse.statusCode == 200) {
    return placeResponseDecoded['data']['data']
        .map<Place>((place) => Place.fromJson(place))
        .toList();
  } else {
    throw Exception('Failed to load place');
  }
}

class Place {
  final dynamic id;
  final dynamic authorId;
  final dynamic name;
  final dynamic location;
  final dynamic description;
  final dynamic rating;
  final dynamic ratingCount;
  final dynamic createdAt;
  final dynamic imgUrl;
  final dynamic isWishlisted;

  const Place({
    required this.id,
    required this.authorId,
    required this.imgUrl,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.ratingCount,
    required this.isWishlisted,
    required this.createdAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      authorId: json['author_id'],
      imgUrl: json['img_urls'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      rating: json['rating'],
      ratingCount: json['rated_by_count'],
      isWishlisted: json['is_wishlisted'],
      createdAt: json['created_at'],
    );
  }
}
