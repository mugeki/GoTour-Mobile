import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Place>> fetchPlaces(
    double page, String keyword, String sortBy) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final placeResponse = await http.get(Uri.parse(
      "${dotenv.env['BE_API_URL']}/place?page=$page&keyword=$keyword&limit=$sortBy"));
  final wishlistResponse = await http
      .get(Uri.parse("${dotenv.env['BE_API_URL']}/wishlist"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });

  var placeResponseDecoded = jsonDecode(placeResponse.body);
  var wishlistResponseDecoded = jsonDecode(wishlistResponse.body);

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

// Service for get My Places
Future<List<Place>> fetchMyPlaces() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final placeResponse = await http
      .get(Uri.parse("${dotenv.env['BE_API_URL']}/my-place"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });
  final wishlistResponse = await http
      .get(Uri.parse("${dotenv.env['BE_API_URL']}/wishlist"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });

  var placeResponseDecoded = jsonDecode(placeResponse.body);
  var wishlistResponseDecoded = jsonDecode(wishlistResponse.body);

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

Future<Place> fetchPlace(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final placeResponse =
      await http.get(Uri.parse("${dotenv.env['BE_API_URL']}/place/$id"));
  final wishlistResponse = await http
      .get(Uri.parse("${dotenv.env['BE_API_URL']}/wishlist"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });

  var placeResponseDecoded = jsonDecode(placeResponse.body);
  var wishlistResponseDecoded = jsonDecode(wishlistResponse.body);

  placeResponseDecoded['data']['is_wishlisted'] =
      wishlistResponseDecoded['data'].any(
          (wishlist) => wishlist['id'] == placeResponseDecoded['data']['id']);

  if (placeResponse.statusCode == 200) {
    return Place.fromJson(placeResponseDecoded['data']);
  } else {
    throw Exception('Failed to load place');
  }
}

// Service for Edit Place
Future<Place> putPlace(int id, Place place) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final placeResponse = await http
      .put(Uri.parse("${dotenv.env['BE_API_URL']}/place/$id"), headers: {
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
    // HttpHeaders.contentTypeHeader: "application/json",
  }, body: <String, String, String>{
    'name': place.name,
    'location': place.location,
    'description': place.description,
    // 'img_urls': place.img_urls,
  });

  if (placeResponse.statusCode == 200) {
    return Place.fromJson(jsonDecode(placeResponse.body)['data']);
  } else {
    throw Exception('Failed to edit place');
  }
}

Future<Place> putRatePlace(int id, int rating) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final placeResponse = await http.put(
    Uri.parse("${dotenv.env['BE_API_URL']}/place/$id/rate"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    },
    body: <String, String>{
      'rating': rating.toString(),
    },
  );

  var placeResponseDecoded = jsonDecode(placeResponse.body);

  if (placeResponse.statusCode == 200) {
    return Place.fromJson(placeResponseDecoded['data']);
  } else {
    print(placeResponseDecoded);
    throw Exception('Failed to rate place');
  }
}

Future toggleWishlistPlace(int id, bool isWishlisted) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final http.Response response;
  if (isWishlisted) {
    response = await http.delete(
      Uri.parse("${dotenv.env['BE_API_URL']}/wishlist/$id"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      },
    );
  } else {
    response = await http.post(
      Uri.parse("${dotenv.env['BE_API_URL']}/wishlist/$id"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      },
    );
  }

  if (response.statusCode == 200) {
    return "$id ${isWishlisted ? 'removed' : 'added'} to wishlist";
  } else {
    print(response);
    throw Exception('Failed to wishlist place');
  }
}

Future postPlace(String name, location, description) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final apiUrl = "${dotenv.env['BE_API_URL']}/place";
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'location': location,
      'description': description,
      // 'image': place.imgUrl,
    }),
  );

  dynamic decodedResponse;
  if (response.body.isEmpty) {
    return response.statusCode;
  }
  decodedResponse = Place.fromJson(jsonDecode(response.body));
  return decodedResponse;
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
