import 'package:frigo_exp/manager/manager.dart';

import '../elements/elements.dart';
import '../objects/objects.dart';

class GroceryListAddScreen extends StatefulWidget {
  final GroceryList? groceryList;
  const GroceryListAddScreen({
    super.key,
    this.groceryList
  });

  @override
  _GroceryListAddScreenController createState() => _GroceryListAddScreenController();
}

class _GroceryListAddScreenController extends State<GroceryListAddScreen> {

  List<GroceryItem> items = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    if(widget.groceryList != null) {
      items.addAll(widget.groceryList!.items);
    }
    for(GroceryItem item in items) {
      controllers.add(TextEditingController(text: item.name));
    }
    controllers.add(TextEditingController(text: ""));
  }

  onChanged(val, index) {
    if(index == controllers.length-1) {
      GroceryItem newItem = GroceryItem(
        ragicId: -1,
        listId: widget.groceryList?.ragicId ?? -1,
        name: val ?? "",
        checked: false
      );
      items.add(newItem);
      controllers.add(TextEditingController(text: ""));
    } else {
      items[index].name = val ?? "";
    }
    setState(() {});
  }

  onSave() {
    if(widget.groceryList != null) {
      widget.groceryList!.items = items;
      GroceryListManager.getState().saveListToApi(widget.groceryList, items);
    } else {
      GroceryListManager.getState().saveListToApi(null, items);
    }
  }

  @override
  Widget build(BuildContext context) => _GroceryListAddScreenView(this);
}

class _GroceryListAddScreenView extends WidgetView<GroceryListAddScreen, _GroceryListAddScreenController> {
  _GroceryListAddScreenView(_GroceryListAddScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: state.onSave,
              child: const Text("Edit")
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: state.controllers.length,
        itemBuilder: (context, index) {
          return TextField(
            controller: state.controllers[index],
            onChanged: (String? val) => state.onChanged(val, index),
          );
        }
      ),
    );
  }
}