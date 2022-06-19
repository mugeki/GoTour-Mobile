import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  SearchBarState createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  final queryCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(10),
      // margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: queryCtrl,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 1, bottom: 1),
                hintText: "Search places",
                fillColor: Colors.grey[200],
                filled: true,
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: (Colors.grey[200])!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: (Colors.grey[200])!),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.filter_list,
                  size: 25,
                ),
                items: [
                  ...FilterItems.firstItems.map(
                    (item) => DropdownMenuItem<FilterItem>(
                      value: item,
                      child: FilterItems.buildItem(item),
                    ),
                  ),
                ],
                onChanged: (value) {
                  FilterItems.onChanged(context, value as FilterItem);
                },
                dropdownWidth: 140,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                // dropdownElevation: 8,
                offset: const Offset(-100, 100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterItem {
  final String text;
  final IconData icon;

  const FilterItem({
    required this.text,
    required this.icon,
  });
}

class FilterItems {
  static const List<FilterItem> firstItems = [date, rating];

  static const date =
      FilterItem(text: 'Date added', icon: Icons.calendar_month);
  static const rating = FilterItem(text: 'Rating', icon: Icons.star);

  static Widget buildItem(FilterItem item) {
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

  static onChanged(BuildContext context, FilterItem item) {
    switch (item) {
      case FilterItems.date:
        //Do something
        break;
      case FilterItems.rating:
        //Do something
        break;
    }
  }
}
