import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/city_database_helper.dart';
import '../../../other/widgets/error_load_data_widget.dart';
import '../../../other/widgets/load_data_widget.dart';
import '../../data/repositories/city_repository_impl.dart';
import '../../state/selection_cities_state.dart';
import '../lists/selection_city_list.dart';
import '../widgets/search_city_text_field.dart';

class SelectionCityPage extends StatefulWidget {
  const SelectionCityPage({
    super.key,
    required this.country,
  });

  final String country;

  @override
  State<SelectionCityPage> createState() => _SelectionCityPageState();
}

class _SelectionCityPageState extends State<SelectionCityPage> {
  late final TextEditingController _editingController;
  late final AllCitiesState _state;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _state = AllCitiesState(CityRepositoryImpl(CityDatabaseHelper()), widget.country);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _waitForTransition();
      if (mounted) _state.loadAllCitiesList();
    });
  }

  Future<void> _waitForTransition() {
    final anim = ModalRoute.of(context)?.animation;
    if (anim == null || anim.isCompleted) return Future.value();

    final completer = Completer<void>();
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        anim.removeStatusListener(listener);
        completer.complete();
      }
    }

    anim.addStatusListener(listener);
    return completer.future;
  }

  @override
  void dispose() {
    _editingController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _state,
      child: Scaffold(
        appBar: AppBar(
          notificationPredicate: (_) => false,
          title: const Text(AppStrings.selectionCity),
        ),
        body: Column(
          children: [
            SearchCityTextField(editingController: _editingController),
            Expanded(
              child: Consumer<AllCitiesState>(
                builder: (context, state, _) {
                  if (state.error != null) {
                    return ErrorLoadDataWidget(
                      errorMessage: state.error.toString(),
                    );
                  }

                  if (state.isLoading) {
                    return const LoadDataWidget();
                  }

                  return SelectionCityList(
                    cities: state.cities,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
