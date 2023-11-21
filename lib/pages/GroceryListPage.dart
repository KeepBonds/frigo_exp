import 'package:frigo_exp/objects/objects.dart';

import '../elements/elements.dart';
import '../manager/manager.dart';
import 'GroceryListAddScreen.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  _GroceryListPageController createState() => _GroceryListPageController();
}

class _GroceryListPageController extends State<GroceryListPage> {
  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList() async {
    await GroceryListManager.getState().loadListFromApi();
    print("GROCERY LIST LOADED");
    setState(() {});
  }

  onTap(GroceryList list) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroceryListAddScreen(groceryList: list,)),
    ).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => _GroceryListPageView(this);
}

class _GroceryListPageView extends WidgetView<GroceryListPage, _GroceryListPageController> {
  _GroceryListPageView(_GroceryListPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: GroceryListManager.getState().lists.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(GroceryListManager.getState().lists[index].items.length.toString()),
          onTap: () => state.onTap(GroceryListManager.getState().lists[index]),
        );
      },
    );
  }
}