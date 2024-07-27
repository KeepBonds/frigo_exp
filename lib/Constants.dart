import 'objects/FridgeProduct.dart';

class ProductType {
  static const String fruit = "FRUIT";
  static const String veggies = "VEGGIES";
  static const String dairy = "DAIRY";
  static const String carbs = "CARBS";
  static const String meat = "MEAT";
  static const String other = "OTHER";
}

class Names {
  static const String name01 = 'Tomato';
  static const String name02 = 'Cucumber';
  static const String name03 = 'Zucchini';
  static const String name04 = 'Bell pepper';
  static const String name05 = 'Milk';
  static const String name52 = 'Soy Milk';
  static const String name06 = 'Eggs';
  static const String name48 = 'Egg Yolk';
  static const String name07 = 'Lettuce';
  static const String name08 = 'Carrot';
  static const String name09 = 'Apple';
  static const String name10 = 'Watermelon';
  static const String name11 = 'Yogurt';
  static const String name12 = 'Potato';
  static const String name13 = 'Sweet Potato';
  static const String name14 = 'Bread';
  static const String name15 = 'Mango';
  static const String name16 = 'Canned Tuna';
  static const String name17 = 'Pasta';
  static const String name18 = 'Rice';
  static const String name19 = 'Bacon';
  static const String name20 = 'Lentils';
  static const String name21 = 'Sausage';
  static const String name22 = 'Greek Yogurt';
  static const String name23 = 'Chia Seed';
  static const String name24 = 'Bread Crumbs';
  static const String name25 = 'Paprika';
  static const String name26 = 'Parmesan';
  static const String name27 = 'Cauliflower';
  static const String name28 = 'Strawberry';
  static const String name29 = 'Shredded Cheese';
  static const String name30 = 'Lasagna';
  static const String name31 = 'Tomato Sauce Arrabiata';
  static const String name32 = 'Onion';
  static const String name33 = 'Ground Beef';
  static const String name34 = 'Lemon';
  static const String name35 = 'White Wine';
  static const String name36 = 'Salmon Fillet';
  static const String name37 = 'Maple Syrup';
  static const String name38 = 'Peanut Butter';
  static const String name39 = 'Pate feuilletée';
  static const String name40 = 'Vanilla Extract';
  static const String name41 = 'Chocolate Chips';
  static const String name42 = 'Cocoa Powder';
  static const String name43 = 'Vanilla Casein Powder';
  static const String name44 = 'Baking Powder';
  static const String name45 = 'Whey Protein Cookie Cream';
  static const String name46 = 'Cinnamon';
  static const String name47 = 'Vanilla Sugar';
  static const String name49 = 'Fresh Cream';
  static const String name50 = 'Dark Chocolate';
  static const String name51 = 'Oatmeal';
  static const String name53 = 'Sugar';
  static const String name54 = 'Black Pepper';
  static const String name55 = 'Salt';
  static const String name56 = 'Salted Butter';
  static const String name57 = 'Brown Sugar';
  static const String name58 = 'Almond Powder';
  static const String name59 = 'Flour';
}

class ExpiryDays {
  static const int tomatoExpiry = 10;
  static const int cucumberExpiry = 7;
  static const int zucchiniExpiry = 7;
  static const int bellPepperExpiry = 8;
  static const int milkExpiry = 14;
  static const int soyMilkExpiry = 30;
  static const int eggsExpiry = 30;
  static const int eggYolkExpiry = 7;
  static const int lettuceExpiry = 12;
  static const int carrotExpiry = 20;
  static const int appleExpiry = 15;
  static const int watermelonExpiry = 4;
  static const int yogurtExpiry = 10;
  static const int potatoExpiry = 20;
  static const int sweetpotatoExpiry = 20;
  static const int breadExpiry = 8;
  static const int mangoExpiry = 5;
  static const int cannedTunaExpiry = 365;
  static const int pastaExpiry = 365;
  static const int riceExpiry = 365;
  static const int baconExpiry = 14;
  static const int lentilsExpiry = 365;
  static const int sausageExpiry = 14;
  static const int greekYogurtExpiry = 10;
  static const int chiaSeedExpiry = 365;
  static const int breadCrumbsExpiry = 90;
  static const int paprikaExpiry = 365;
  static const int parmesanExpiry = 180;
  static const int cauliflowerExpiry = 14;
  static const int strawberryExpiry = 7;
  static const int shreddedCheeseExpiry = 14;
  static const int lasagnaExpiry = 365;
  static const int tomatoSauceArrabiataExpiry = 365;
  static const int onionExpiry = 30;
  static const int groundBeefExpiry = 7;
  static const int lemonExpiry = 14;
  static const int whiteWineExpiry = 365;
  static const int salmonFilletExpiry = 7;
  static const int mapleSyrupExpiry = 365;
  static const int peanutButterExpiry = 365;
  static const int pateFeuilleteeExpiry = 90;
  static const int vanillaExtractExpiry = 365;
  static const int chocolateChipsExpiry = 365;
  static const int cocoaPowderExpiry = 365;
  static const int vanillaCaseinPowderExpiry = 365;
  static const int bakingPowderExpiry = 365;
  static const int wheyProteinCookieCreamExpiry = 365;
  static const int cinnamonExpiry = 365;
  static const int vanillaSugarExpiry = 365;
  static const int freshCreamExpiry = 14;
  static const int darkChocolateExpiry = 365;
  static const int oatmealExpiry = 180;
  static const int sugarExpiry = 365;
  static const int blackPepperExpiry = 365;
  static const int saltExpiry = 365;
  static const int saltedButterExpiry = 180;
  static const int brownSugarExpiry = 365;
  static const int almondPowderExpiry = 365;
  static const int flourExpiry = 365;

  // Add methods for new products
  static int getExpiry(String name) {
    switch (name) {
      case Names.name01: return tomatoExpiry;
      case Names.name02: return cucumberExpiry;
      case Names.name03: return zucchiniExpiry;
      case Names.name04: return bellPepperExpiry;
      case Names.name05: return milkExpiry;
      case Names.name06: return eggsExpiry;
      case Names.name07: return lettuceExpiry;
      case Names.name08: return carrotExpiry;
      case Names.name09: return appleExpiry;
      case Names.name10: return watermelonExpiry;
      case Names.name11: return yogurtExpiry;
      case Names.name12: return potatoExpiry;
      case Names.name13: return sweetpotatoExpiry;
      case Names.name14: return breadExpiry;
      case Names.name15: return mangoExpiry;
      case Names.name16: return cannedTunaExpiry;
      case Names.name17: return pastaExpiry;
      case Names.name18: return riceExpiry;
      case Names.name19: return baconExpiry;
      case Names.name20: return lentilsExpiry;
      case Names.name21: return sausageExpiry;
      case Names.name22: return greekYogurtExpiry;
      case Names.name23: return chiaSeedExpiry;
      case Names.name24: return breadCrumbsExpiry;
      case Names.name25: return paprikaExpiry;
      case Names.name26: return parmesanExpiry;
      case Names.name27: return cauliflowerExpiry;
      case Names.name28: return strawberryExpiry;
      case Names.name29: return shreddedCheeseExpiry;
      case Names.name30: return lasagnaExpiry;
      case Names.name31: return tomatoSauceArrabiataExpiry;
      case Names.name32: return onionExpiry;
      case Names.name33: return groundBeefExpiry;
      case Names.name34: return lemonExpiry;
      case Names.name35: return whiteWineExpiry;
      case Names.name36: return salmonFilletExpiry;
      case Names.name37: return mapleSyrupExpiry;
      case Names.name38: return peanutButterExpiry;
      case Names.name39: return pateFeuilleteeExpiry;
      case Names.name40: return vanillaExtractExpiry;
      case Names.name41: return chocolateChipsExpiry;
      case Names.name42: return cocoaPowderExpiry;
      case Names.name43: return vanillaCaseinPowderExpiry;
      case Names.name44: return bakingPowderExpiry;
      case Names.name45: return wheyProteinCookieCreamExpiry;
      case Names.name46: return cinnamonExpiry;
      case Names.name47: return vanillaSugarExpiry;
      case Names.name48: return eggYolkExpiry;
      case Names.name49: return freshCreamExpiry;
      case Names.name50: return darkChocolateExpiry;
      case Names.name51: return oatmealExpiry;
      case Names.name52: return soyMilkExpiry;
      case Names.name53: return sugarExpiry;
      case Names.name54: return blackPepperExpiry;
      case Names.name55: return saltExpiry;
      case Names.name56: return saltedButterExpiry;
      case Names.name57: return brownSugarExpiry;
      case Names.name58: return almondPowderExpiry;
      case Names.name59: return flourExpiry;
      default: return 0;
    }
  }
}

List<FridgeProduct> products = [
  FridgeProduct(name: Names.name01, daysTillExpiry: ExpiryDays.getExpiry(Names.name01), assetName: "assets/images/tomato.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name02, daysTillExpiry: ExpiryDays.getExpiry(Names.name02), assetName: "assets/images/cucumber.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name03, daysTillExpiry: ExpiryDays.getExpiry(Names.name03), assetName: "assets/images/zucchini.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name04, daysTillExpiry: ExpiryDays.getExpiry(Names.name04), assetName: "assets/images/bellpepper.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name05, daysTillExpiry: ExpiryDays.getExpiry(Names.name05), assetName: "assets/images/milk.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name52, daysTillExpiry: ExpiryDays.getExpiry(Names.name52), assetName: "assets/images/soymilk.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name06, daysTillExpiry: ExpiryDays.getExpiry(Names.name06), assetName: "assets/images/egg.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name48, daysTillExpiry: ExpiryDays.getExpiry(Names.name48), assetName: "assets/images/eggyolk.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name07, daysTillExpiry: ExpiryDays.getExpiry(Names.name07), assetName: "assets/images/lettuce.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name08, daysTillExpiry: ExpiryDays.getExpiry(Names.name08), assetName: "assets/images/carrot.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name09, daysTillExpiry: ExpiryDays.getExpiry(Names.name09), assetName: "assets/images/apple.png", type: ProductType.fruit),
  FridgeProduct(name: Names.name10, daysTillExpiry: ExpiryDays.getExpiry(Names.name10), assetName: "assets/images/watermelon.png", type: ProductType.fruit),
  FridgeProduct(name: Names.name11, daysTillExpiry: ExpiryDays.getExpiry(Names.name11), assetName: "assets/images/yogurt.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name12, daysTillExpiry: ExpiryDays.getExpiry(Names.name12), assetName: "assets/images/potato.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name13, daysTillExpiry: ExpiryDays.getExpiry(Names.name13), assetName: "assets/images/sweetpotato.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name14, daysTillExpiry: ExpiryDays.getExpiry(Names.name14), assetName: "assets/images/bread.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name15, daysTillExpiry: ExpiryDays.getExpiry(Names.name15), assetName: "assets/images/mango.png", type: ProductType.fruit),
  FridgeProduct(name: Names.name16, daysTillExpiry: ExpiryDays.getExpiry(Names.name16), assetName: "assets/images/cannedtuna.png", type: ProductType.other),
  FridgeProduct(name: Names.name17, daysTillExpiry: ExpiryDays.getExpiry(Names.name17), assetName: "assets/images/pasta.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name18, daysTillExpiry: ExpiryDays.getExpiry(Names.name18), assetName: "assets/images/rice.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name19, daysTillExpiry: ExpiryDays.getExpiry(Names.name19), assetName: "assets/images/bacon.png", type: ProductType.meat),
  FridgeProduct(name: Names.name20, daysTillExpiry: ExpiryDays.getExpiry(Names.name20), assetName: "assets/images/lentils.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name21, daysTillExpiry: ExpiryDays.getExpiry(Names.name21), assetName: "assets/images/sausage.png", type: ProductType.meat),
  FridgeProduct(name: Names.name22, daysTillExpiry: ExpiryDays.getExpiry(Names.name22), assetName: "assets/images/greekyogurt.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name23, daysTillExpiry: ExpiryDays.getExpiry(Names.name23), assetName: "assets/images/chiaseed.png", type: ProductType.other),
  FridgeProduct(name: Names.name24, daysTillExpiry: ExpiryDays.getExpiry(Names.name24), assetName: "assets/images/breadcrumbs.png", type: ProductType.other),
  FridgeProduct(name: Names.name25, daysTillExpiry: ExpiryDays.getExpiry(Names.name25), assetName: "assets/images/paprika.png", type: ProductType.other),
  FridgeProduct(name: Names.name26, daysTillExpiry: ExpiryDays.getExpiry(Names.name26), assetName: "assets/images/parmesan.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name27, daysTillExpiry: ExpiryDays.getExpiry(Names.name27), assetName: "assets/images/cauliflower.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name28, daysTillExpiry: ExpiryDays.getExpiry(Names.name28), assetName: "assets/images/strawberry.png", type: ProductType.fruit),
  FridgeProduct(name: Names.name29, daysTillExpiry: ExpiryDays.getExpiry(Names.name29), assetName: "assets/images/shreddedcheese.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name30, daysTillExpiry: ExpiryDays.getExpiry(Names.name30), assetName: "assets/images/lasagna.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name31, daysTillExpiry: ExpiryDays.getExpiry(Names.name31), assetName: "assets/images/tomatosaucearrabiata.png", type: ProductType.other),
  FridgeProduct(name: Names.name32, daysTillExpiry: ExpiryDays.getExpiry(Names.name32), assetName: "assets/images/onion.png", type: ProductType.veggies),
  FridgeProduct(name: Names.name33, daysTillExpiry: ExpiryDays.getExpiry(Names.name33), assetName: "assets/images/groundbeef.png", type: ProductType.meat),
  FridgeProduct(name: Names.name34, daysTillExpiry: ExpiryDays.getExpiry(Names.name34), assetName: "assets/images/lemon.png", type: ProductType.fruit),
  FridgeProduct(name: Names.name35, daysTillExpiry: ExpiryDays.getExpiry(Names.name35), assetName: "assets/images/whitewine.png", type: ProductType.other),
  FridgeProduct(name: Names.name36, daysTillExpiry: ExpiryDays.getExpiry(Names.name36), assetName: "assets/images/salmonfillet.png", type: ProductType.meat),
  FridgeProduct(name: Names.name37, daysTillExpiry: ExpiryDays.getExpiry(Names.name37), assetName: "assets/images/maplesyrup.png", type: ProductType.other),
  FridgeProduct(name: Names.name38, daysTillExpiry: ExpiryDays.getExpiry(Names.name38), assetName: "assets/images/peanutbutter.png", type: ProductType.other),
  FridgeProduct(name: Names.name39, daysTillExpiry: ExpiryDays.getExpiry(Names.name39), assetName: "assets/images/patefeuilletee.png", type: ProductType.other),
  FridgeProduct(name: Names.name40, daysTillExpiry: ExpiryDays.getExpiry(Names.name40), assetName: "assets/images/vanillaextract.png", type: ProductType.other),
  FridgeProduct(name: Names.name41, daysTillExpiry: ExpiryDays.getExpiry(Names.name41), assetName: "assets/images/chocolatechips.png", type: ProductType.other),
  FridgeProduct(name: Names.name42, daysTillExpiry: ExpiryDays.getExpiry(Names.name42), assetName: "assets/images/cocoapowder.png", type: ProductType.other),
  FridgeProduct(name: Names.name43, daysTillExpiry: ExpiryDays.getExpiry(Names.name43), assetName: "assets/images/vanillacaseinpowder.png", type: ProductType.other),
  FridgeProduct(name: Names.name44, daysTillExpiry: ExpiryDays.getExpiry(Names.name44), assetName: "assets/images/bakingpowder.png", type: ProductType.other),
  FridgeProduct(name: Names.name45, daysTillExpiry: ExpiryDays.getExpiry(Names.name45), assetName: "assets/images/wheyproteincookiecream.png", type: ProductType.other),
  FridgeProduct(name: Names.name46, daysTillExpiry: ExpiryDays.getExpiry(Names.name46), assetName: "assets/images/cinnamon.png", type: ProductType.other),
  FridgeProduct(name: Names.name47, daysTillExpiry: ExpiryDays.getExpiry(Names.name47), assetName: "assets/images/vanillasugar.png", type: ProductType.other),
  FridgeProduct(name: Names.name49, daysTillExpiry: ExpiryDays.getExpiry(Names.name49), assetName: "assets/images/freshcream.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name50, daysTillExpiry: ExpiryDays.getExpiry(Names.name50), assetName: "assets/images/darkchocolate.png", type: ProductType.other),
  FridgeProduct(name: Names.name51, daysTillExpiry: ExpiryDays.getExpiry(Names.name51), assetName: "assets/images/oatmeal.png", type: ProductType.carbs),
  FridgeProduct(name: Names.name56, daysTillExpiry: ExpiryDays.getExpiry(Names.name56), assetName: "assets/images/saltedbutter.png", type: ProductType.dairy),
  FridgeProduct(name: Names.name53, daysTillExpiry: ExpiryDays.getExpiry(Names.name53), assetName: "assets/images/sugar.png", type: ProductType.other),
  FridgeProduct(name: Names.name54, daysTillExpiry: ExpiryDays.getExpiry(Names.name54), assetName: "assets/images/blackpepper.png", type: ProductType.other),
  FridgeProduct(name: Names.name55, daysTillExpiry: ExpiryDays.getExpiry(Names.name55), assetName: "assets/images/salt.png", type: ProductType.other),
  FridgeProduct(name: Names.name57, daysTillExpiry: ExpiryDays.getExpiry(Names.name57), assetName: "assets/images/brownsugar.png", type: ProductType.other),
  FridgeProduct(name: Names.name58, daysTillExpiry: ExpiryDays.getExpiry(Names.name58), assetName: "assets/images/almondpowder.png", type: ProductType.other),
  FridgeProduct(name: Names.name59, daysTillExpiry: ExpiryDays.getExpiry(Names.name59), assetName: "assets/images/flour.png", type: ProductType.other),
];

List<FridgeProduct> getFilteredList(List<String> types) {
  if(types.isEmpty) {
    List<FridgeProduct> p = products;
    p.sort((a, b) {
      return a.type.compareTo(b.type);
    });
    return p.reversed.toList();
  } else {
    List<FridgeProduct> p = products.where((element) => types.contains(element.type)).toList();
    p.sort((a, b) {
      return a.type.compareTo(b.type);
    });
    return p.reversed.toList();
  }
}

List<FridgeProduct> getList() {
  List<FridgeProduct> p = products;
  p.sort((a, b) {
    return a.type.compareTo(b.type);
  });
  return p.reversed.toList();
}