import 'package:flutter/material.dart';

import '../../domain/entities/city_entity.dart';
import '../items/selection_city_item.dart';

class SelectionCityList extends StatelessWidget {
  const SelectionCityList({
    super.key,
    required this.cities,
    required this.searchQuery,
  });

  final List<CityEntity> cities;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final filteredList = searchQuery.isEmpty ? cities : cities.where((c) {
      return c.city.toLowerCase().contains(searchQuery) || c.country.toLowerCase().contains(searchQuery) || c.iso.toLowerCase().contains(searchQuery);
    }).toList();

    return Scrollbar(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final cityModel = filteredList[index];
          return SelectionCityItem(
            cityModel: cityModel,
            index: index,
          );
        },
      ),
    );
  }
}
