class GroceryItem {
  int ragicId = -1;
  int listId = -1;
  String name = "";
  int seq = -1;
  bool checked = false;

  GroceryItem({
    required this.ragicId,
    required this.listId,
    required this.name,
    required this.seq,
    required this.checked,
  });

  GroceryItem.mock()
      : ragicId = -100000000,
        listId = -100000000,
        name = "",
        seq = -100000000,
        checked = false;

  GroceryItem.fromApi(Map<String, dynamic> json, int parentListId)
      : ragicId = json['_ragicId'] ?? -1,
        listId = parentListId,
        name = json['1000311'] ?? "",
        seq = int.tryParse(json['1000344']) ?? -1,
        checked = json['1000312'] == "true";

  Map<String, dynamic> toApi() => {
    "_ragicId": ragicId,
    "1000311": name,
    "1000344": seq.toString(),
    "1000312": checked.toString(),
  };

  static GroceryItem fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      ragicId: json["ragicId"],
      listId: json["listId"],
      name: json["name"],
      seq: json["seq"],
      checked: json["checked"],
    );
  }

  Map<String, dynamic> toJson() =>{
    "ragicId": ragicId,
    "listId": listId,
    "name": name,
    "seq": seq,
    "checked": checked,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}