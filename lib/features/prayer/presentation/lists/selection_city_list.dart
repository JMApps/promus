import 'package:flutter/material.dart';

import '../../../other/widgets/search_is_empty_widget.dart';
import '../../domain/entities/city_entity.dart';
import '../items/selection_city_item.dart';

class SelectionCityList extends StatelessWidget {
  const SelectionCityList({
    super.key,
    required this.cities,
  });

  final List<CityEntity> cities;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const SearchIsEmptyWidget();
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final cityModel = cities[index];
          return SelectionCityItem(
            cityModel: cityModel,
            index: index,
          );
        },
      ),
    );
  }
}
