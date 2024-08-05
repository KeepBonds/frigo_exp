import 'dart:convert';
import '../objects/FridgeProduct.dart';
import '../cache/StorageHelperManager.dart';
import 'NotificationService.dart';
import 'package:timezone/timezone.dart' as tz;

class FridgeManager {
  static FridgeManager? _manager;

  List<FridgeProduct> _products = [];
  List<FridgeProduct> get products => _products;

  FridgeManager._internal() {
    _products = [];
  }

  static FridgeManager getState() {
    return _manager ??= FridgeManager._internal();
  }

  void reset() {
    _products = [];
  }

  loadProducts() async {
    String productsToJson = await StorageHelperManager.getString("Products") ?? "";
    if(productsToJson.isNotEmpty) {
      List<dynamic> encoded = jsonDecode(productsToJson);
      List<FridgeProduct> loadedProducts = [];
      for (dynamic element in encoded) {
        loadedProducts.add(FridgeProduct.fromJson(element));
      }

      _products = loadedProducts;
    } else {
      _products = [];
    }
  }

  void addProducts(List<FridgeProduct> selectedProducts) {
    if(selectedProducts.isEmpty) return;

    List<FridgeProduct> updatedProducts = [];
    for(FridgeProduct fridgeProduct in selectedProducts) {
      FridgeProduct p = fridgeProduct;
      p.timeOfPurchase = DateTime.now();
      updatedProducts.add(p);

      if(p.daysTillExpiry < 40) {
        tz.TZDateTime expirationTime = tz.TZDateTime.now(tz.local).add(Duration(days: p.daysTillExpiry - 1));
        NotificationService().scheduleNotification(id: p.id, title: '${fridgeProduct.name} expires soon', body: 'Quantity: ${fridgeProduct.quantity} left', scheduledNotificationDateTime: expirationTime);
      }
    }
    _products.addAll(updatedProducts);
    saveProducts(_products);
  }

  void removeProducts(FridgeProduct selectedProducts) {
    NotificationService().deleteScheduledNotification(selectedProducts.id);
    _products.remove(selectedProducts);
    saveProducts(_products);
  }

  void updateQuantityProducts(FridgeProduct product, int quantity) {
    if(quantity == 0) {
      removeProducts(product);
    } else {
      int index = _products.indexOf(product);
      _products[index].quantity = quantity;
    }
    saveProducts(_products);
  }

  void updateTime(FridgeProduct product, DateTime time) {
    int index = _products.indexOf(product);
    _products[index].timeOfPurchase = time;

    saveProducts(_products);
  }

  Future<void> saveProducts(List<FridgeProduct> products) async {
    _products = products;

    List<Map<String, dynamic>> encode = [];
    for (FridgeProduct element in products) {
      encode.add(element.toJson());
    }

    String productsToJson = jsonEncode(encode);
    await StorageHelperManager.setString("Products", productsToJson);
  }

  Future<void> loadSettings() async {
    await loadProducts();
  }
}