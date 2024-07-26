import 'package:frigo_exp/objects/objects.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../elements/elements.dart';
import '../../manager/manager.dart';
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
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 8.0),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          children: GroceryListManager.getState().lists.map<Widget> ((item) {
            return Container(
                child: Card(
                  child: InkWell(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.getItemDisplay()),
                        Text(item.date)
                      ],
                    ),
                    onTap: () => state.onTap(item),
                  ),
                ));
          }).toList(),
        ),
      ),
    );

    return GridView.builder(
        itemCount: GroceryListManager.getState().lists.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // Set the maximum cross-axis extent
          crossAxisSpacing: 8, // Set the spacing between each item
          mainAxisSpacing: 8, // Set the spacing between rows
        ),
        itemBuilder: (context, index) {
          return Container(
            child: InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(GroceryListManager.getState().lists[index].getItemDisplay()),
                  Text(GroceryListManager.getState().lists[index].date)
                ],
              ),
              onTap: () => state.onTap(GroceryListManager.getState().lists[index]),
            ),
          );
        }
    );
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

