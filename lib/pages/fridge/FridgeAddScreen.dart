import 'package:flutter/material.dart';
import '../../Constants.dart';
import '../../manager/manager.dart';
import '../../objects/objects.dart';
import 'package:frigo_exp/elements/FontAwesomeIcons.dart';

class FridgeAddScreen extends StatefulWidget {
  const FridgeAddScreen({super.key});

  @override
  _FridgeAddScreenState createState() => _FridgeAddScreenState();
}

class _FridgeAddScreenState extends State<FridgeAddScreen> {
  List<FridgeProduct> selectedProducts = [];

  List<String> productType = [];

  @override
  void initState() {
    super.initState();
  }

  onPressedFilter(String type) {
    if(productType.contains(type)) {
      productType.remove(type);
    } else {
      productType.add(type);
    }
    setState(() {});
  }

  void onTapAddProduct(FridgeProduct fridgeProduct) {
    if(selectedProducts.contains(fridgeProduct)) {
      selectedProducts.remove(fridgeProduct);
    } else {
      selectedProducts.add(fridgeProduct);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<FridgeProduct> fridgeProductList = getFilteredList(productType);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Fridge', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: selectedProducts.isEmpty ? null : () {
              FridgeManager.getState().addProducts(selectedProducts);
              Navigator.pop(context);
            },
            child: const Text("Add")
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.fruit),
                    text: "Fruits",
                    icon: FontAwesome.lemon,
                    onTap: () => onPressedFilter(ProductType.fruit),
                  ),
                  const SizedBox(width: 8.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.veggies),
                    text: "Veggies",
                    icon: FontAwesome.salad,
                    onTap: () => onPressedFilter(ProductType.veggies),
                  ),
                  const SizedBox(width: 8.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.dairy),
                    text: "Dairy",
                    icon: FontAwesome.cow,
                    onTap: () => onPressedFilter(ProductType.dairy),
                  ),
                  const SizedBox(width: 8.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.carbs),
                    text: "Carbs",
                    icon: FontAwesome.bread,
                    onTap: () => onPressedFilter(ProductType.carbs),
                  ),
                  const SizedBox(width: 8.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.meat),
                    text: "Meat",
                    icon: FontAwesome.meat,
                    onTap: () => onPressedFilter(ProductType.meat),
                  ),
                  const SizedBox(width: 8.0,),
                  FridgeChipFilter(
                    selected: productType.contains(ProductType.other),
                    text: "Other",
                    icon: FontAwesome.other,
                    onTap: () => onPressedFilter(ProductType.other),
                  ),
                  const SizedBox(width: 16.0,),
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                ),
                itemCount: fridgeProductList.length,
                itemBuilder: (context, index) {
                  return FridgeProductCard(
                    fridgeProduct: fridgeProductList[index],
                    isSelected: selectedProducts.contains(fridgeProductList[index]),
                    onTapAddProduct: onTapAddProduct,
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }
}

class FridgeProductCard extends StatelessWidget {
  const FridgeProductCard({
    Key? key,
    required this.fridgeProduct,
    required this.isSelected,
    required this.onTapAddProduct
  }) : super(key: key);

  final FridgeProduct fridgeProduct;
  final bool isSelected;
  final Function(FridgeProduct) onTapAddProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapAddProduct(fridgeProduct),
      child: Card(
        color: isSelected ? Colors.blue : Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
            ),
          margin: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Flexible(child: Image(image: AssetImage(fridgeProduct.assetName))),
              Text(fridgeProduct.name),
              const SizedBox(height: 20,),
            ],
          ),
        )
      ),
    );
  }
}


class FridgeChipFilter extends StatelessWidget {
  final bool selected;
  final String text;
  final IconData icon;
  final Function() onTap;

  const FridgeChipFilter({super.key, required this.selected, required this.text, required this.icon, required this.onTap});

  TextStyle get unSelectedTextStyle => const TextStyle(color: Colors.black87);
  TextStyle get selectedTextStyle => const TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onTap,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: selected ? Colors.red : Colors.black87)
        ),
        label: Row(
          children: [
            Text(text, style: selected ? selectedTextStyle : unSelectedTextStyle,),
            const SizedBox(width: 8.0,),
            Icon(icon, color: selected ? Colors.red : Colors.black87, size: 15,),
          ],
        ),
      ),
    );
  }
}
