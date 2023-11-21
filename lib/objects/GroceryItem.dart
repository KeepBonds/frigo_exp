class GroceryItem {
  int ragicId = -1;
  int listId = -1;
  String name = "";
  bool checked = false;

  GroceryItem({
    required this.ragicId,
    required this.listId,
    required this.name,
    required this.checked,
  });

  GroceryItem.fromApi(Map<String, dynamic> json, int parentListId)
      : ragicId = json['_ragicId'] ?? -1,
        listId = parentListId,
        name = json['1000311'] ?? "",
        checked = json['1000312'] == "true";

  Map<String, dynamic> toApi() =>{
    "_ragicId": ragicId,
    "1000311": name,
    "1000312": checked,
  };

  static GroceryItem fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      ragicId: json["ragicId"],
      listId: json["listId"],
      name: json["name"],
      checked: json["checked"],
    );
  }

  Map<String, dynamic> toJson() =>{
    "ragicId": ragicId,
    "listId": listId,
    "name": name,
    "checked": checked,
  };
}