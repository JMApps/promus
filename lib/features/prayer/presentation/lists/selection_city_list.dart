import 'package:material_ui/material_ui.dart';

import '../../../other/widgets/search_is_empty_widget.dart';
import '../../domain/entities/city_entity.dart';
import '../items/selection_city_item.dart';

class SelectionCityList extends StatelessWidget {
  const SelectionCityList({
    super.key,
    required this.allCitiesList,
  });

  final List<CityEntity> allCitiesList;

  @override
  Widget build(BuildContext context) {
    if (allCitiesList.isEmpty) {
      return const SearchIsEmptyWidget();
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: allCitiesList.length,
        itemBuilder: (context, index) {
          final cityModel = allCitiesList[index];
          return SelectionCityItem(
            cityModel: cityModel,
            index: index,
          );
        },
      ),
    );
  }
}
