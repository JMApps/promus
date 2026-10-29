import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/city_database_helper.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../data/repositories/city_repository_impl.dart';
import '../../domain/entities/city_entity.dart';
import '../../state/selection_cities_state.dart';
import '../lists/selection_city_list.dart';
import '../widgets/search_city_text_field.dart';

class SelectionCityPage extends StatefulWidget {
  const SelectionCityPage({super.key});

  @override
  State<SelectionCityPage> createState() => _SelectionCityPageState();
}

class _SelectionCityPageState extends State<SelectionCityPage> {
  late final CityDatabaseHelper _cityDatabaseHelper;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();

    _editingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CityDatabaseHelper.instance.db.then((_) {}, onError: (_) {});
    });

    _cityDatabaseHelper = CityDatabaseHelper.instance;
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllCitiesState(
        CityRepositoryImpl(_cityDatabaseHelper),
      ),
      child: Scaffold(
        appBar: AppBar(
          notificationPredicate: (_) => false,
          title: const Text(AppStrings.selectionCity),
        ),
        body: Consumer<AllCitiesState>(
          builder: (context, allCitiesState, _) {
            return FutureBuilder<List<CityEntity>>(
              future: allCitiesState.fetchAllCities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: AppPaddings.medium,
                      child: Text(
                        '${AppStrings.errorLoadData}\n${snapshot.error}',
                        textAlign: .center,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    SearchCityTextField(
                      editingController: _editingController,
                    ),
                    Expanded(
                      child: SelectionCityList(
                        cities: snapshot.data!,
                        searchQuery: allCitiesState.searchQuery,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
