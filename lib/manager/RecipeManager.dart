import 'dart:convert';
import '../cache/cache.dart';
import '../manager/manager.dart';
import '../objects/objects.dart';

class RecipeManager {
  static RecipeManager? _manager;

  DateTime? lastLoaded;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  List<Recipe> getRecipes(MealType? filterType) {
    if(isItemFiltered) {
      return getItemFilteredRecipes(filterType);
    }
    return getFilteredRecipes(filterType);
  }

  List<Recipe> getFilteredRecipes(MealType? filterType) => filterType == null ? recipes : _recipes.where((element) => filterType == element.type).toList();

  FridgeProduct? itemFilter;
  bool get isItemFiltered => itemFilter != null;
  void clearItemFilter() => itemFilter = null;

  List<Recipe> getItemFilteredRecipes(MealType? filterType) {
    List<Recipe> itemFilteredRecipes = [];
    if(itemFilter == null) return [];

    for(Recipe recipe in recipes) {
      if(recipe.ingredients.where((element) => element.name.toLowerCase() == itemFilter!.name.toLowerCase()).isNotEmpty) {
        itemFilteredRecipes.add(recipe);
      }
    }
    if(filterType != null) {
      return itemFilteredRecipes.where((element) => filterType == element.type).toList();
    }
    return itemFilteredRecipes;
  }

  RecipeManager._internal() {
    _recipes = [];
    itemFilter = null;
  }

  static RecipeManager getState() {
    return _manager ??= RecipeManager._internal();
  }

  loadRecipesFromApi({bool force = false}) async {
    if(!force && lastLoaded != null && DateTime.now().difference(lastLoaded!).compareTo(const Duration(minutes: 5)) < 0) {
      await loadRecipesFromCache();
      return;
    }

    Response response = await ApiManager(
        apiMethod: ApiMethod.GET,
        url: "https://www.ragic.com/acdu92/recettes/1",
        parameters: ApiParameters.getData
    ).call();

    List<Recipe> recipesFromApi = [];
    if(response.data is Map) {
      response.data.forEach((key, value) {
        Recipe recipe = Recipe.fromApi(value);
        recipesFromApi.add(recipe);
      });
    }
    _recipes = recipesFromApi;

    lastLoaded = DateTime.now();
    saveRecipesToCache();
  }

  loadRecipesFromCache() async {
    String cacheString = await StorageHelperManager.getString(StorageKeys.recipes) ?? "";
    if(cacheString.isNotEmpty) {
      List<dynamic> encoded = jsonDecode(cacheString);
      List<Recipe> loadedRecipes = [];
      for (dynamic element in encoded) {
        loadedRecipes.add(Recipe.fromJson(element));
      }
      _recipes = loadedRecipes;
    } else {
      _recipes = [];
    }
  }

  saveRecipesToCache() async {
    List<Map<String, dynamic>> encode = [];
    for (Recipe element in _recipes) {
      encode.add(element.toJson());
    }

    String recipesToJson = jsonEncode(encode);
    await StorageHelperManager.setString(StorageKeys.recipes, recipesToJson);
  }


}