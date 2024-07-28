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

  onLongPress(GroceryList list) async {
    bool confirm = await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Delete ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
        ],
      );
    });
    if(confirm) {
      await GroceryListManager.getState().deleteAPI(list);
      setState(() {});
    }
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
                        if(item.name.isNotEmpty) Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 2,),
                        Container(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 2.0),
                          child: Text(item.getItemDisplay()),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(item.date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black54)),
                        )
                      ],
                    ),
                  ),
                  onTap: () => state.onTap(item),
                  onLongPress: () => state.onLongPress(item),
                )
            );
          }).toList(),
        ),
      ),
    );
  }
}

