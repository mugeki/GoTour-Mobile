import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gotour_mobile/screens/detail.dart';
import 'package:gotour_mobile/screens/edit_place_form.dart';
import 'package:gotour_mobile/widgets/wishlist_btn.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard(
      {Key? key,
      required this.id,
      required this.imgUrl,
      required this.name,
      required this.location,
      required this.description,
      required this.rating,
      required this.ratingCount,
      required this.isWishlisted,
      this.refreshList,
      this.isCarousel = false,
      this.isMyPlace = false})
      : super(key: key);

  final bool isCarousel;
  final bool isMyPlace;
  final List<dynamic> imgUrl;
  final String location;
  final String name;
  final String description;
  final double rating;
  final int ratingCount;
  final int id;
  final bool isWishlisted;
  final ValueChanged<int>? refreshList;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Detail(id: id)));
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
                  height: 100,
                  child: Image.network(
                    imgUrl[0],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
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
                              child: Text(location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300)),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: rating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star_rounded,
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
                          WishlistBtn(id: id, isWishlishted: isWishlisted),
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
                                onChanged: (value) async {
                                  // MenuItems.onChanged(
                                  //     context, value as MenuItem);
                                  switch (value) {
                                    case MenuItems.edit:
                                      //Do something
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPlaceForm(
                                                      name: name,
                                                      location: location,
                                                      description:
                                                          description)));
                                      break;
                                    case MenuItems.delete:
                                      refreshList!(id);
                                      break;
                                  }
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
}
