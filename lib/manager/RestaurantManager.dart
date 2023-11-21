import 'dart:convert';
import '../cache/cache.dart';
import '../helper/FileHelper.dart';
import '../helper/UploadFileHelper.dart';
import '../manager/manager.dart';
import '../objects/objects.dart';

class RestaurantManager {
  static RestaurantManager? _manager;

  List<Restaurant> _restaurant = [];
  List<Restaurant> get restaurant => _restaurant;

  DateTime? lastLoaded;

  RestaurantManager._internal() {
    _restaurant = [];
  }

  static RestaurantManager getState() {
    return _manager ??= RestaurantManager._internal();
  }

  addRestaurant(Restaurant newRestaurant) {
    _restaurant.add(newRestaurant);
  }

  loadRestaurantsFromApi() async {
    if(lastLoaded != null && DateTime.now().difference(lastLoaded!).compareTo(const Duration(minutes: 5)) < 0) {
      await loadRestaurantsFromCache();
      return;
    }

    Response response = await ApiManager(
        apiMethod: ApiMethod.GET,
        url: "https://www.ragic.com/acdu92/restaurants/2",
        parameters: ApiParameters.getData
    ).call();

    List<Restaurant> restaurantsFromApi = [];
    if(response.data is Map) {
      response.data.forEach((key, value) {
        Restaurant restaurant = Restaurant.fromApi(value);
        restaurantsFromApi.add(restaurant);
      });
    }
    _restaurant = restaurantsFromApi;

    lastLoaded = DateTime.now();
    saveRestaurantsToCache();
  }

  loadRestaurantsFromCache() async {
    String cacheString = await StorageHelperManager.getString(StorageKeys.restaurant) ?? "";
    if(cacheString.isNotEmpty) {
      List<dynamic> encoded = jsonDecode(cacheString);
      List<Restaurant> loadedRestaurant = [];
      for (dynamic element in encoded) {
        loadedRestaurant.add(Restaurant.fromJson(element));
      }
      _restaurant = loadedRestaurant;
    } else {
      _restaurant = [];
    }
  }

  saveRestaurantsToCache() async {
    List<Map<String, dynamic>> encode = [];
    for (Restaurant element in _restaurant) {
      encode.add(element.toJson());
    }

    String restaurantToJson = jsonEncode(encode);
    await StorageHelperManager.setString(StorageKeys.restaurant, restaurantToJson);
  }

  saveToApi(Restaurant? restaurant, String name, String address, List<dynamic> pictures) async {
    String url = 'https://www.ragic.com/acdu92/restaurants/2/${(restaurant?.ragicId ?? -1)}';
    // UPLOAD IMAGES
    List<dynamic> uploadedImages = [];
    if(FileHelper.hasFile(pictures)) {
      uploadedImages = await UploadFileHelper.uploadPicture(url, "1000304", pictures);
    }

    // SAVE API
    if (restaurant != null) {
      uploadedImages.addAll(restaurant.image);
    }

    Map<String, dynamic> data = {};
    data['_ragicId'] = restaurant?.ragicId ?? -1;
    data['_star'] = false;
    data["1000302"] = name; // name
    data["1000303"] = address;
    data["1000304"] = uploadedImages;

    Response saveResponse = await ApiManager(
        apiMethod: ApiMethod.POST,
        url: url,
        parameters: ApiParameters.saveData,
        postData: data
    ).call();

    if(restaurant != null) {
      Iterable<Restaurant> restaurantIte = RestaurantManager.getState().restaurant.where((element) => restaurant.ragicId == element.ragicId);
      restaurantIte.first.name = name;
      restaurantIte.first.location = address;
      restaurantIte.first.image = uploadedImages;
    } else {
      Restaurant newRestaurant = Restaurant(
        ragicId: saveResponse.data["ragicId"] ?? -1,
        name: name,
        location: address,
        image: uploadedImages,
      );
      addRestaurant(newRestaurant);
    }
    saveRestaurantsToCache();
  }
}