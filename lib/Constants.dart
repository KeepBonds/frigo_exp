import 'objects/FridgeProduct.dart';

class ProductType {
  static const String fruit = "FRUIT";
  static const String veggies = "VEGGIES";
  static const String dairy = "DAIRY";
  static const String carbs = "CARBS";
}


class Names {
  static const String name01 = 'Tomato';
  static const String name02 = 'Cucumber';
  static const String name03 = 'Zucchini';
  static const String name04 = 'Bell pepper';
  static const String name05 = 'Milk';
  static const String name06 = 'Eggs';
  static const String name07 = 'Lettuce';
  static const String name08 = 'Carrot';
  static const String name09 = 'Apple';
  static const String name10 = 'Watermelon';
  static const String name11 = 'Yogurt';
  static const String name12 = 'Potato';
  static const String name13 = 'Sweet Potato';
  static const String name14 = 'Bread';
  static const String name15 = 'Mango';
}

class ExpiryDays {
  static const int tomatoExpiry = 10;
  static const int cucumberExpiry = 7;
  static const int zucchiniExpiry = 7;
  static const int bellPepperExpiry = 8;
  static const int milkExpiry = 14;
  static const int eggsExpiry = 30;
  static const int lettuceExpiry = 12;
  static const int carrotExpiry = 20;
  static const int appleExpiry = 15;
  static const int watermelonExpiry = 4;
  static const int yogurtExpiry = 10;
  static const int potatoExpiry = 20;
  static const int sweetpotatoExpiry = 20;
  static const int breadExpiry = 8;
  static const int mangoExpiry = 5;

  static int getTomatoExpiry () {
    return tomatoExpiry;
  }
  static  int getCucumberExpiry() {
    return cucumberExpiry;
  }
  static  int getZucchiniExpiry() {
    return zucchiniExpiry;
  }
  static int getBellpepperExpiry() {
    return bellPepperExpiry;
  }
  static  int getMilkExpiry () {
    return milkExpiry;
  }
  static  int getEggsExpiry () {
    return eggsExpiry;
  }
  static  int getLettuceExpiry () {
    return lettuceExpiry;
  }
  static  int getCarrotExpiry () {
    return carrotExpiry;
  }
  static  int getAppleExpiry () {
    return appleExpiry;
  }
  static  int getWatermelonExpiry() {
    return watermelonExpiry;
  }
  static  int getYogurtExpiry () {
    return yogurtExpiry;
  }
  static  int getPotatoExpiry () {
    return potatoExpiry;
  }
  static  int getSweetPotatoExpiry () {
    return sweetpotatoExpiry;
  }
  static  int getBreadExpiry() {
    return breadExpiry;
  }
  static  int getMangoExpiry() {
    return mangoExpiry;
  }
}


List<FridgeProduct> products = [
  FridgeProduct(
    name: Names.name01,
    daysTillExpiry: ExpiryDays.getTomatoExpiry(),
    assetName: "assets/images/tomato.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name02,
    daysTillExpiry: ExpiryDays.getCucumberExpiry(),
    assetName: "assets/images/cucumber.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name03,
    daysTillExpiry: ExpiryDays.getZucchiniExpiry(),
    assetName: "assets/images/zucchini.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name04,
    daysTillExpiry: ExpiryDays.getBellpepperExpiry(),
    assetName: "assets/images/bellpepper.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name05,
    daysTillExpiry: ExpiryDays.getMilkExpiry(),
    assetName: "assets/images/milk.png",
    type: ProductType.dairy,
  ),
  FridgeProduct(
    name: Names.name06,
    daysTillExpiry: ExpiryDays.getEggsExpiry(),
    assetName: "assets/images/egg.png",
    type: ProductType.dairy,
  ),
  FridgeProduct(
    name: Names.name07,
    daysTillExpiry: ExpiryDays.getLettuceExpiry(),
    assetName: "assets/images/lettuce.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name08,
    daysTillExpiry: ExpiryDays.getCarrotExpiry(),
    assetName: "assets/images/carrot.png",
    type: ProductType.veggies,
  ),
  FridgeProduct(
    name: Names.name09,
    daysTillExpiry: ExpiryDays.getAppleExpiry(),
    assetName: "assets/images/apple.png",
    type: ProductType.fruit,
  ),
  FridgeProduct(
    name: Names.name10,
    daysTillExpiry: ExpiryDays.getWatermelonExpiry(),
    assetName: "assets/images/watermelon.png",
    type: ProductType.fruit,
  ),
  FridgeProduct(
    name: Names.name11,
    daysTillExpiry: ExpiryDays.getYogurtExpiry(),
    assetName: "assets/images/yogurt.png",
    type: ProductType.dairy,
  ),
  FridgeProduct(
    name: Names.name12,
    daysTillExpiry: ExpiryDays.getPotatoExpiry(),
    assetName: "assets/images/potato.png",
    type: ProductType.carbs,
  ),
  FridgeProduct(
    name: Names.name13,
    daysTillExpiry: ExpiryDays.getSweetPotatoExpiry(),
    assetName: "assets/images/sweetpotato.png",
    type: ProductType.carbs,
  ),
  FridgeProduct(
    name: Names.name14,
    daysTillExpiry: ExpiryDays.getBreadExpiry(),
    assetName: "assets/images/bread.png",
    type: ProductType.carbs,
  ),
  FridgeProduct(
    name: Names.name15,
    daysTillExpiry: ExpiryDays.getMangoExpiry(),
    assetName: "assets/images/mango.png",
    type: ProductType.fruit,
  ),
];

List<FridgeProduct> getList() {
  List<FridgeProduct> p = products;
  p.sort((a, b) {
    return a.type.compareTo(b.type);
  });
  return p.reversed.toList();
}