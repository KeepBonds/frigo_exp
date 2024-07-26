import 'package:flutter/material.dart';
import 'package:frigo_exp/manager/FridgeManager.dart';
import '../../Constants.dart';
import '../../objects/FridgeProduct.dart';

class FridgeAddScreen extends StatefulWidget {
  const FridgeAddScreen({super.key});

  @override
  _FridgeAddScreenState createState() => _FridgeAddScreenState();
}

class _FridgeAddScreenState extends State<FridgeAddScreen> {
  List<FridgeProduct> selectedProducts = [];  

  @override
  void initState() {
    super.initState();
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
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
        ),
        itemCount: getList().length,
        itemBuilder: (context, index) {
          return FridgeProductCard(
            fridgeProduct: getList()[index],
            isSelected: selectedProducts.contains(getList()[index]),
            onTapAddProduct: onTapAddProduct,
          );
        },
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
          color: Colors.white,
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


