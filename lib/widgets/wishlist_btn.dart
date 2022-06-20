import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';

class WishlistBtn extends StatefulWidget {
  final bool isWishlishted;
  final int id;

  const WishlistBtn({Key? key, required this.id, required this.isWishlishted})
      : super(key: key);

  @override
  State<WishlistBtn> createState() => _WishlistBtnState();
}

class _WishlistBtnState extends State<WishlistBtn> {
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.isWishlishted;
  }

  void _toggleWishlist() {
    setState(() {
      if (_isWishlisted) {
        _isWishlisted = false;
      } else {
        _isWishlisted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.grey,
      icon: _isWishlisted
          ? const Icon(Icons.bookmark)
          : const Icon(Icons.bookmark_border),
      onPressed: () async {
        await toggleWishlistPlace(widget.id, _isWishlisted);
        _toggleWishlist();
        final snackBar = SnackBar(
          content: Text(
              "Place has been ${_isWishlisted ? 'added to' : 'removed from'} your wishlist"),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      iconSize: 30,
    );
  }
}
