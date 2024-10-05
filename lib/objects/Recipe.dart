import 'dart:io';

import '../helper/UploadFileHelper.dart';
import '../manager/manager.dart';

enum MealType {
  Repas,
  Dessert,
  PtitDej,
  Drinks,
  Prep,
  Test,
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
  int ragicId;
  String name = ""; // 1000231
  MealType type = MealType.Repas; // 1000220
  List<Ingredient> ingredients = []; // sub => _subtable_1000226
  List<Step> steps = []; // sub => _subtable_1000227
  String image = ""; // 1000301

  Recipe({
    required this.ragicId,
    required this.name,
    required this.type,
    required this.ingredients,
    required this.steps,
    required this.image
  });

  factory Recipe.fromApi(Map<String, dynamic> json) {
    return Recipe(
      ragicId: json['_ragicId'] ?? -1000,
      name: json['1000231'] ?? "",
      type: getType(json['1000220']),
      image: json['1000301'] ?? "",
      ingredients: getIngredient(json['_subtable_1000226']),
      steps: getSteps(json['_subtable_1000227']),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      ragicId: json['ragicId'] ?? "",
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
      'ragicId': ragicId,
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
      case "Drink":
        return MealType.Drinks;
      case "Test":
        return MealType.Test;
      case "Prep":
        return MealType.Prep;
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

  saveImageApi(File image) async {
    String url = 'https://www.ragic.com/acdu92/recettes/1/$ragicId';
    // UPLOAD IMAGES
    List<dynamic> uploadedImages = await UploadFileHelper.uploadPicture(url, "1000301", [image]);
    // SAVE API
    Map<String, dynamic> data = {};
    data["1000301"] = uploadedImages;

    Response saveResponse = await ApiManager(
        apiMethod: ApiMethod.POST,
        url: url,
        parameters: ApiParameters.saveData,
        postData: data
    ).call();
  }
}

class Ingredient {
  String name = ""; // 1000222
  double dosage = -1; // 1000221
  MeasureType measure; // 1000232

  Ingredient({
    required this.name,
    required this.dosage,
    required this.measure,
  });

  factory Ingredient.fromApi(Map<String, dynamic> json) {
    return Ingredient(
      name: json['1000222'] ?? "",
      dosage: double.tryParse(json['1000221']) ?? -1,
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
    print("value $value");
    switch(value) {
      case "G":
        return MeasureType.G;
      case "ML":
        return MeasureType.ML;
      case "CL":
        return MeasureType.CL;
      case "tsp/cac/5ml":
      case "cac/5ml":
        return MeasureType.cac;
      case "tbsp/cas/15ml":
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
