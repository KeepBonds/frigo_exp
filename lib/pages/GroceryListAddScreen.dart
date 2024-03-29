import 'package:frigo_exp/manager/manager.dart';

import '../elements/elements.dart';
import '../objects/objects.dart';

class GroceryItemController {
  GroceryItem item;
  TextEditingController controller;

  GroceryItemController(this.item, this.controller);
}

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
  List<GroceryItemController> controllers = [];

  @override
  void initState() {
    super.initState();
    if(widget.groceryList != null) {
      items.addAll(widget.groceryList!.items);
      items.sort((a, b) => a.seq.compareTo(b.seq));
    }
    for(GroceryItem item in items) {
      controllers.add(GroceryItemController(item, TextEditingController(text: item.name)));
    }
    controllers.add(GroceryItemController(GroceryItem.mock(), TextEditingController(text: "")));
  }

  onChanged(val, index) {
    if(index == controllers.length-1) {
      GroceryItem newItem = GroceryItem(
        ragicId: -1,
        listId: widget.groceryList?.ragicId ?? -1,
        name: val ?? "",
        checked: false,
        seq: index
      );
      controllers[index].item = newItem;
      controllers.add(GroceryItemController(GroceryItem.mock(), TextEditingController(text: "")));
    } else {
      controllers[index].item.name = val ?? "";
    }
    setState(() {});
  }

  onChecked(bool? check, int index) {
    if(check == null) return;

    controllers[index].item.checked = check;
    setState(() {});
  }

  onChangedSeq(int? newSeq, int index) {
    if(newSeq == null) return;

    if (index < newSeq) {
      newSeq -= 1;
    }
    final GroceryItemController item = controllers.removeAt(index);
    controllers.insert(newSeq, item);

    for(int  i = 0 ; i < controllers.length ; i++) {
      controllers[i].item.seq = i;
    }

    setState(() {});
  }

  onSave() {
    List<GroceryItem> saveItems = [];
    for(GroceryItemController controller in controllers) {
      if(controller.item.ragicId == -100000000) continue;
      saveItems.add(controller.item);
    }

    if(widget.groceryList != null) {
      GroceryListManager.getState().saveListToApi(widget.groceryList, saveItems);
    } else {
      GroceryListManager.getState().saveListToApi(null, saveItems);
    }
    Navigator.pop(context);
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
              child: const Text("Save")
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: state.controllers.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('$index'),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 11),
                  child: Icon(Icons.drag_indicator),
                ),
                Checkbox(
                    value: state.controllers[index].item.checked,
                    onChanged: (bool? check) => state.onChecked(check, index)
                ),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none
                    ),
                    controller: state.controllers[index].controller,
                    onChanged: (String? val) => state.onChanged(val, index),
                  ),
                )
              ],
            ),
          );
        },
        onReorder:  (int oldIndex, int newIndex) => state.onChangedSeq(newIndex, oldIndex),
      )
    );
  }
}