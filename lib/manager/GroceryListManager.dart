import 'dart:convert';

import 'package:frigo_exp/objects/GroceryList.dart';
import 'package:intl/intl.dart';

import '../cache/cache.dart';
import '../objects/objects.dart';
import '../manager/manager.dart';

class GroceryListManager {
  static GroceryListManager? _manager;

  DateTime? lastLoaded;

  List<GroceryList> _lists = [];
  List<GroceryList> get lists => _lists;

  GroceryListManager._internal() {
    _lists = [];
  }

  static GroceryListManager getState() {
    return _manager ??= GroceryListManager._internal();
  }

  loadListFromApi() async {
    if(lastLoaded != null && DateTime.now().difference(lastLoaded!).compareTo(const Duration(minutes: 5)) < 0) {
      await loadListFromCache();
      return;
    }
    _lists = [];
    Response response = await ApiManager(
        apiMethod: ApiMethod.GET,
        url: "https://www.ragic.com/acdu92/grocery/4",
        parameters: ApiParameters.getData,
    ).call();

    List<GroceryList> listFromApi = [];
    if(response.data is Map) {
      response.data.forEach((key, value) {
        GroceryList list = GroceryList.fromApi(value);
        listFromApi.add(list);
      });
    }
    _lists = listFromApi;

    lastLoaded = DateTime.now();
    saveListToCache();
  }

  loadListFromCache() async {
    String cacheString = await StorageHelperManager.getString(StorageKeys.groceryList) ?? "";
    if(cacheString.isNotEmpty) {
      List<dynamic> encoded = jsonDecode(cacheString);
      List<GroceryList> loadedProducts = [];
      for (dynamic element in encoded) {
        loadedProducts.add(GroceryList.fromJson(element));
      }
      _lists = loadedProducts;
    } else {
      _lists = [];
    }
  }

  saveListToCache() async {
    List<Map<String, dynamic>> encode = [];
    for (GroceryList element in _lists) {
      encode.add(element.toJson());
    }

    String listoJson = jsonEncode(encode);
    await StorageHelperManager.setString(StorageKeys.groceryList, listoJson);
  }

  saveListToApi(GroceryList? list, List<GroceryItem> items) async {
    String todayDate = DateFormat("yyyy/MM/dd").format(DateTime.now());
    
    Map<String, dynamic> data = {};
    data['_ragicId'] = list?.ragicId ?? -1;
    data['_star'] = false;
    data["1000310"] = todayDate;

    Map<String, dynamic> subTableData = {};
    for(int i = 0 ; i<items.length ; i++) {
      if(items[i].ragicId == -1) {
        items[i].ragicId = -(1000-i);
      }
      print(items[i].toApi().toString());
      subTableData[items[i].ragicId.toString()] = items[i].toApi();
    }
    data['_subtable_1000314'] = subTableData;

    Response saveResponse = await ApiManager(
        apiMethod: ApiMethod.POST,
        url: "https://www.ragic.com/acdu92/grocery/4/${(list?.ragicId ?? -1)}",
        parameters: ApiParameters.saveData,
        postData: data
    ).call();

    if(list != null) {
      int ind = lists.indexWhere((element) => list.ragicId == element.ragicId);
      if(ind != -1) {
        lists[ind] = GroceryList.fromApi(saveResponse.data['data']);
      }
    } else {
      GroceryList newList = GroceryList(
        ragicId: saveResponse.data["ragicId"] ?? -1,
        date: todayDate,
        items: items,
      );
      _lists.add(newList);
    }
    saveListToCache();
  }
}