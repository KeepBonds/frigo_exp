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
        margin: const EdgeInsets.all(8.0),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          children: GroceryListManager.getState().lists.map<Widget> ((item) {
            return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(item.name.isNotEmpty) Text(item.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                        Text(item.getItemDisplay()),
                        Text(item.date)
                      ],
                    ),
                  ),
                  onTap: () => state.onTap(item),
                )
            );
          }).toList(),
        ),
      ),
    );
  }
}

