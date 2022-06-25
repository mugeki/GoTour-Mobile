import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:gotour_mobile/widgets/search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String _searchQuery;
  late String _sortBy;

  static const _pageSize = 9;
  final PagingController<int, Place> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _searchQuery = "";
    _sortBy = "created_at";
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _searchQuery, _sortBy);
    });
  }

  Future<void> _fetchPage(
    int pageKey,
    String keyword,
    String sortBy,
  ) async {
    try {
      final newItems = await fetchPlaces(1, _searchQuery, _sortBy);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void onSubmitSearchBar(String query) {
    _searchQuery = query;
    _pagingController.refresh();
  }

  void onSortChanged(String sortBy) {
    _sortBy = sortBy;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SearchBar(
            onSubmitSearchBar: onSubmitSearchBar,
            onSortChanged: onSortChanged,
          ),
          elevation: 0,
          backgroundColor: Colors.grey[50],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: PagedListView<int, Place>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Place>(
            itemBuilder: (context, item, index) => PlaceCard(
              id: item.id,
              isCarousel: false,
              isMyPlace: false,
              imgUrl: item.imgUrl,
              location: item.location,
              name: item.name,
              rating: double.parse(item.rating),
              ratingCount: item.ratingCount,
              isWishlisted: item.isWishlisted,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
