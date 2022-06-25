import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FilterItem {
  final String text;
  final String value;
  final IconData icon;

  const FilterItem({
    required this.text,
    required this.value,
    required this.icon,
  });
}

class SearchBar extends StatefulWidget {
  final Function(String) onSubmitSearchBar;
  final Function(String) onSortChanged;
  const SearchBar(
      {Key? key, required this.onSubmitSearchBar, required this.onSortChanged})
      : super(key: key);

  @override
  SearchBarState createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  final queryCtrl = TextEditingController();
  String? _activeItem;
  final List<FilterItem> dropdownItems = [
    const FilterItem(
        text: 'Date added', value: "created_at", icon: Icons.calendar_month),
    const FilterItem(text: 'Rating', value: "rating", icon: Icons.star)
  ];

  @override
  void initState() {
    super.initState();
    _activeItem = "created_at";
  }

  void onChangeDropdownItem(FilterItem item) {
    setState(() {
      _activeItem = item.value;
    });
    widget.onSortChanged(item.value);
  }

  // void onSubmit() {
  //   widget.onSubmitSearchBar(queryCtrl.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      margin: const EdgeInsets.only(top: 10),
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
              onSubmitted: (value) {
                widget.onSubmitSearchBar(queryCtrl.text);
              },
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
                  ...dropdownItems.map(
                    (item) => DropdownMenuItem<FilterItem>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: _activeItem == item.value
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            item.text,
                            style: TextStyle(
                              color: _activeItem == item.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  onChangeDropdownItem(value as FilterItem);
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
