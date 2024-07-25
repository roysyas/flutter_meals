import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/filters_enum.dart';
import 'package:meals/provider/meal_provider.dart';

class FilterNotifier extends StateNotifier<Map<FiltersEnum, bool>> {
  FilterNotifier()
      : super({
          FiltersEnum.gluttenFree: false,
          FiltersEnum.lactoseFree: false,
          FiltersEnum.vegetarian: false,
          FiltersEnum.vegan: false,
        }); // initial data

  void setFilter(FiltersEnum filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<FiltersEnum, bool> choosenFilters) {
    state = choosenFilters;
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, Map<FiltersEnum, bool>>(
  (ref) => FilterNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filterProvider);

  return meals.where((meal) {
    if (activeFilters[FiltersEnum.gluttenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[FiltersEnum.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[FiltersEnum.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[FiltersEnum.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
