import '../../elements/elements.dart';
import '../../manager/manager.dart';
import '../../objects/objects.dart';

class FridgePage extends StatefulWidget {
  @override
  _FridgePageController createState() => _FridgePageController();
}

class _FridgePageController extends State<FridgePage> {
  onDismissed(FridgeProduct product) {
    FridgeManager.getState().removeProducts(product);
    setState(() {});
  }

  updateQuantityProducts(FridgeProduct product, int quantity) {
    FridgeManager.getState().updateQuantityProducts(product, quantity);
    setState(() {});
  }

  updateProductDate(FridgeProduct product) async {
    int index = FridgeManager.getState().products.indexOf(product);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: FridgeManager.getState().products[index].timeOfPurchase!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != FridgeManager.getState().products[index].timeOfPurchase) {
      setState(() {
        FridgeManager.getState().updateTime(product, picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) => _FridgePageView(this);
}

class _FridgePageView extends WidgetView<FridgePage, _FridgePageController> {
  _FridgePageView(_FridgePageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: FridgeManager.getState().products.length,
        itemBuilder: (context, index) {
          return ProductsItem(
            product: FridgeManager.getState().products[index],
            onDismissed: state.onDismissed,
            onUpdateQuantity: state.updateQuantityProducts,
            updateProductDate: state.updateProductDate,
          );
        }
    );
  }
}