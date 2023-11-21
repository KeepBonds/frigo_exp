import 'dart:convert';
import '../cache/cache.dart';
import '../manager/manager.dart';
import '../objects/objects.dart';

class RecipeManager {
  static RecipeManager? _manager;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  List<Recipe> getFilteredRecipes(MealType? filterType) => filterType == null ? recipes : _recipes.where((element) => filterType == element.type).toList();

  DateTime? lastLoaded;

  RecipeManager._internal() {
    _recipes = [];
  }

  static RecipeManager getState() {
    return _manager ??= RecipeManager._internal();
  }

  loadRecipesFromApi() async {
    if(lastLoaded != null && DateTime.now().difference(lastLoaded!).compareTo(const Duration(minutes: 5)) < 0) {
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