import 'package:flutter/material.dart';
import '../objects/FridgeProduct.dart';

class ProductsItem extends StatelessWidget {
  final FridgeProduct product;
  final Function(FridgeProduct) onDismissed;
  final Function(FridgeProduct, int) onUpdateQuantity;
  final Function(FridgeProduct) updateProductDate;

  const ProductsItem({
    Key? key,
    required this.product,
    required this.onDismissed,
    required this.onUpdateQuantity,
    required this.updateProductDate
  }) : super(key: key);

  Widget differenceWidget() {
    if(product.timeOfPurchase == null) {
      return Container();
    }

    Duration beforeExpiry = product.timeOfPurchase!.add(Duration(days: product.daysTillExpiry)).difference(DateTime.now());
    int days = beforeExpiry.inDays;
    Color color = Colors.green;

    if(days < 2) {
      color = Colors.red;
    }else if (days < 5) {
      color = Colors.orangeAccent;
    }

    return InkWell(
      onTap: () => updateProductDate(product),
      child: Container(
        width: 40,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(4.0),
        child: Text("${beforeExpiry.inDays}d", style: TextStyle(color: color),),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(product.name+product.timeOfPurchase.toString()),
        onDismissed: (direction) {
          onDismissed(product);
        },
        child: ListTile(
          leading: Image(
            image: AssetImage(product.assetName),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(product.name)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white70,
                        minimumSize: const Size(35, 35),
                        fixedSize: const Size(35, 35),
                        padding: const EdgeInsets.symmetric(horizontal: 1.0)
                    ),
                    child: const Icon(Icons.remove, color: Colors.black),
                    onPressed:  () => onUpdateQuantity(product, product.quantity-1),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(product.quantity.toString()),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white70,
                        minimumSize: const Size(35, 35),
                        fixedSize: const Size(35, 35),
                        padding: const EdgeInsets.symmetric(horizontal: 1.0)
                    ),
                    child: const Icon(Icons.add, color: Colors.black),
                    onPressed:  () => onUpdateQuantity(product, product.quantity+1),
                  ),
                ],
              ),
              differenceWidget()
            ],
          ),
        )
    );
  }
}