import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard(
      {Key? key,
      required this.id,
      required this.imgUrl,
      required this.name,
      required this.description,
      required this.rating,
      required this.ratingCount,
      this.isCarousel = false,
      this.isMyPlace = false})
      : super(key: key);

  final bool isCarousel;
  final bool isMyPlace;
  final String imgUrl;
  final String description;
  final String name;
  final double rating;
  final double ratingCount;
  final double id;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
        },
        child: Container(
          margin:
              isCarousel ? const EdgeInsets.symmetric(horizontal: 10) : null,
          width: double.infinity,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: isMyPlace
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text('Bandung, West Java',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: rating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                ),
                                Text('(${ratingCount.toString()})')
                              ],
                            ),
                          ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const WishlistBtn(),
                          if (isMyPlace)
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                customButton: const Icon(
                                  Icons.more_horiz,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                items: [
                                  ...MenuItems.firstItems.map(
                                    (item) => DropdownMenuItem<MenuItem>(
                                      value: item,
                                      child: MenuItems.buildItem(item),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  MenuItems.onChanged(
                                      context, value as MenuItem);
                                },
                                dropdownWidth: 140,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // dropdownElevation: 8,
                                offset: const Offset(-100, 100),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WishlistBtn extends StatefulWidget {
  const WishlistBtn({Key? key}) : super(key: key);

  @override
  State<WishlistBtn> createState() => _WishlistBtnState();
}

class _WishlistBtnState extends State<WishlistBtn> {
  bool _isWishlisted = false;

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
      onPressed: _toggleWishlist,
      iconSize: 30,
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(item.text),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.edit:
        //Do something
        break;
      case MenuItems.delete:
        //Do something
        break;
    }
  }
}
