class FridgeProduct {
  String name;
  int daysTillExpiry;
  String assetName;
  String type;
  int quantity;
  DateTime? timeOfPurchase;

  FridgeProduct({
    required this.name,
    required this.daysTillExpiry,
    required this.assetName,
    required this.type,
    this.quantity = 1,
    this.timeOfPurchase,
  });

  static FridgeProduct fromJson(Map<String, dynamic> json) {
    return FridgeProduct(
        name: json["name"],
        daysTillExpiry: json["daysTillExpiry"],
        assetName: json["assetName"],
        type: json["type"],
        quantity: json["quantity"] ?? 1,
        timeOfPurchase: DateTime.parse(json["timeOfPurchase"])
    );
  }

  Map<String, dynamic> toJson() =>{
   "name": name,
   "daysTillExpiry": daysTillExpiry,
   "assetName": assetName,
    "type": type,
    "quantity": quantity,
   "timeOfPurchase": timeOfPurchase?.toIso8601String() ?? "",
  };
}