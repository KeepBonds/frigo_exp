class Restaurant {
  int ragicId = -1;
  String name = "";
  String location = "";
  List<dynamic> image = [];

  Restaurant({
    this.ragicId = -1,
    required this.name,
    this.location = "",
    this.image = const [],
  });

  factory Restaurant.fromApi(Map<String, dynamic> json) {
    return Restaurant(
      ragicId: json['_ragicId'] ?? -1,
      name: json['1000302'] ?? "",
      location: json['1000303'] ?? "",
      image: (json['1000304'] is List ? json['1000304'] : []) ?? [],
    );
  }

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json["name"],
      location: json["location"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() =>{
    "name": name,
    "location": location,
    "image": image,
  };


  Map<String, dynamic> toRagicEntry() =>{
    "_ragicId": ragicId,
    "_star": false,
    "1000302": name,
    "1000303": location,
    "1000304": image,
  };
}