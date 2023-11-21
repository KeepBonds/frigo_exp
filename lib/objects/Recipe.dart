enum MealType {
  Repas,
  Dessert,
  PtitDej,
}

enum MeasureType {
  Unit,
  G,
  ML,
  CL,
  cac,
  cas,
  Pinch,
  Sachet,
}

class Recipe {
  String name = ""; // 1000231
  MealType type = MealType.Repas; // 1000220
  List<Ingredient> ingredients = []; // sub => _subtable_1000226
  List<Step> steps = []; // sub => _subtable_1000227
  String image = ""; // 1000301

  Recipe({
    required this.name,
    required this.type,
    required this.ingredients,
    required this.steps,
    required this.image
  });

  factory Recipe.fromApi(Map<String, dynamic> json) {
    return Recipe(
      name: json['1000231'] ?? "",
      type: getType(json['1000220']),
      image: json['1000301'] ?? "",
      ingredients: getIngredient(json['_subtable_1000226']),
      steps: getSteps(json['_subtable_1000227']),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? "",
      type: MealType.values[json['type'] ?? 0],
      image: json['image'] ?? "",
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((item) => Ingredient.fromJson(item))
          .toList() ?? [],
      steps: (json['steps'] as List<dynamic>?)
          ?.map((item) => Step.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.index,
      'image': image,
      'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }

  @override
  String toString() => toJson().toString();


  static MealType getType(String? value) {
    switch(value) {
      case "P'tit dej":
        return MealType.PtitDej;
      case "Dessert":
        return MealType.Dessert;
      case "Repas":
      default:
        return MealType.Repas;
    }
  }

  static List<Ingredient> getIngredient(dynamic value) {
    List<Ingredient> ingredients = [];
    if(value != null && value is Map) {
      for(dynamic v in value.values) {
        Ingredient ingredient = Ingredient.fromApi(v);
        ingredients.add(ingredient);
      }
      return ingredients;
    }
    return [];
  }

  static List<Step> getSteps(dynamic value) {
    List<Step> steps = [];
    if(value != null && value is Map) {
      for(int i = 0 ; i<value.values.length ; i++) {
        Step step = Step.fromApi(value.values.elementAt(i), i+1);
        steps.add(step);
      }
      return steps;
    }
    return [];
  }
}

class Ingredient {
  String name = ""; // 1000222
  int dosage = -1; // 1000221
  MeasureType measure; // 1000232

  Ingredient({
    required this.name,
    required this.dosage,
    required this.measure,
  });

  factory Ingredient.fromApi(Map<String, dynamic> json) {
    return Ingredient(
      name: json['1000222'] ?? "",
      dosage: int.tryParse(json['1000221']) ?? -1,
      measure: getType(json['1000232']),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? "",
      dosage: json['dosage'] ?? -1,
      measure: MeasureType.values[json['measure'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'measure': measure.index,
    };
  }

  static MeasureType getType(String? value) {
    switch(value) {
      case "G":
        return MeasureType.G;
      case "ML":
        return MeasureType.ML;
      case "CL":
        return MeasureType.CL;
      case "cac/5ml":
        return MeasureType.cac;
      case "cas/15ml":
        return MeasureType.cas;
      case "Pinch":
        return MeasureType.Pinch;
      case "Sachet":
        return MeasureType.Sachet;
      case "Unit":
      default:
        return MeasureType.Unit;
    }
  }
}

class Step {
  int stepNb = -1; // => just make it order wise
  String information = ""; // 1000224

  Step({
    required this.stepNb,
    required this.information,
  });

  factory Step.fromApi(Map<String, dynamic> json, int step) {
    return Step(
      information: json['1000224'] ?? "",
      stepNb: step,
    );
  }

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNb: json['stepNb'] ?? -1,
      information: json['information'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNb': stepNb,
      'information': information,
    };
  }
}
