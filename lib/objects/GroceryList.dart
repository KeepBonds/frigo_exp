import 'package:flutter/material.dart';

import 'GroceryItem.dart';

class GroceryList {
  int ragicId = -1;
  String name = "";
  String date = "";
  List<GroceryItem> items = [];

  GroceryList({
    required this.ragicId,
    required this.name,
    required this.date,
    required this.items,
  });

  String getItemDisplay() {
    String layout = "";
    List<GroceryItem> sortedList = List.from(items);
    sortedList.sort((a, b) => a.seq.compareTo(b.seq));

    for(GroceryItem item in sortedList) {
      layout += ("${item.name}\n");
    }
    return layout;
  }

  List<Widget> getItemDisplayText() {
    List<Widget> layout = [];
    List<GroceryItem> sortedList = List.from(items);
    sortedList.sort((a, b) => a.seq.compareTo(b.seq));

    for(GroceryItem item in sortedList) {
      layout.add(Text(item.name, style: TextStyle(decoration: item.checked ? TextDecoration.lineThrough: null),));
    }
    return layout;
  }

  GroceryList.fromApi(Map<String, dynamic> json)
      : ragicId = json['_ragicId'] ?? -1,
        name = json['1000351'] ?? "",
        date = json['1000310'] ?? "",
        items = processItems(json['_subtable_1000314'], json['_ragicId'] ?? -1);

  static List<GroceryItem> processItems(Map<String, dynamic>? subTable, int parentId) {
    if(subTable == null) return [];

    List<GroceryItem> items = [];
    for(Map<String, dynamic> value in subTable.values) {
      GroceryItem item = GroceryItem.fromApi(value, parentId);
      items.add(item);
    }
    return items;
  }

  static GroceryList fromJson(Map<String, dynamic> json) {
    return GroceryList(
      ragicId: json["ragicId"],
      name: json["name"],
      date: json["date"],
      items: (json['items'] as List<dynamic>?)
        ?.map((item) => GroceryItem.fromJson(item))
        .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() =>{
    "ragicId": ragicId,
    "name": name,
    "date": date,
    "items": items.map((item) => item.toJson()).toList(),
  };
}