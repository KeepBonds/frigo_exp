import 'package:flutter/services.dart';
import 'package:frigo_exp/manager/manager.dart';

import '../../elements/elements.dart';
import '../../objects/objects.dart';

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

  late TextEditingController nameController;

  List<GroceryItem> items = [];
  List<GroceryItemController> controllers = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.groceryList != null ? widget.groceryList!.name : "");

    if(widget.groceryList != null) {
      items.addAll(widget.groceryList!.items);
      items.sort((a, b) => a.seq.compareTo(b.seq));
    }

    const String invisibleChar = '\u200B';
    for(GroceryItem item in items) {
      controllers.add(GroceryItemController(item, TextEditingController(text: invisibleChar + item.name)));
    }
    controllers.add(GroceryItemController(GroceryItem.mock(), TextEditingController(text: invisibleChar)));
  }

  onChanged(val, index) {
    if(val == null) return;
    print("VAL:" + val + "|  SS? | " + val.length.toString()  );
    if(val.contains("\n")) {
      controllers[index].item.name = val.replaceAll("\n", "");
      controllers[index].controller.text = val.replaceAll("\n", "");
      onAddNewLine(val, index);
      setState(() {});
      return;
    }
    if(val.length == 0) {
      controllers.removeAt(index);
      setState(() {});
      return;
    }

    if(index == controllers.length-1) {
      onAddNewLine(val, index);
    } else {
      controllers[index].item.name = val ?? "";
    }
    setState(() {});
  }

  onAddNewLine(val, index) {
    int newLineIndex = index;
    if(index == controllers.length - 1) {
      newLineIndex = index + 1;
    } else {
      newLineIndex = index + 1;
      for(GroceryItemController gc in controllers) {
        gc.item.seq = gc.item.seq+1;
      }
    }

    GroceryItem newItem = GroceryItem(
        ragicId: -1,
        listId: widget.groceryList?.ragicId ?? -1,
        name: val ?? "",
        checked: false,
        seq: newLineIndex
    );
    controllers[index].item = newItem;
    const String invisibleChar = '\u200B';

    if(index == controllers.length - 1) {
      controllers.add(GroceryItemController(GroceryItem.mock(), TextEditingController(text: invisibleChar)));
    } else {
      controllers.insert(newLineIndex, GroceryItemController(GroceryItem.mock(), TextEditingController(text: invisibleChar)));
    }
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
    String name = nameController.text;

    List<GroceryItem> saveItems = [];
    for(GroceryItemController controller in controllers) {
      if(controller.item.ragicId == -100000000) continue;
      saveItems.add(controller.item);
    }

    if(widget.groceryList != null) {
      GroceryListManager.getState().saveListToApi(widget.groceryList, name, saveItems);
    } else {
      GroceryListManager.getState().saveListToApi(null, name, saveItems);
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Container(
                  key: const Key('t_field'),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: TextField(
                    controller: state.nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: "Title"
                    ),
                  ),
                )
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: state.controllers.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  key: Key('$index'),
                  dense: true,
                  minLeadingWidth: 0.0,
                  minVerticalPadding: 0.0,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                            child: const Icon(Icons.drag_indicator),
                          ),
                        ),
                        Checkbox(
                            value: state.controllers[index].item.checked,
                            onChanged: (bool? check) => state.onChecked(check, index)
                        ),
                        Expanded(
                          child: SuggestionTextField(
                            textEditingController: state.controllers[index].controller,
                            index: index,
                            onChanged: state.onChanged,
                          )
                          //TextField(
                          //  maxLines: null,
                          //  textCapitalization: TextCapitalization.sentences,
                          //  decoration: const InputDecoration(
                          //      focusedBorder: InputBorder.none,
                          //      border: InputBorder.none,
                          //      enabledBorder: InputBorder.none
                          //  ),
                          //  controller: state.controllers[index].controller,
                          //  onChanged: (String? val) => state.onChanged(val, index),
                          //),
                        )
                      ],
                    ),
                  ),
                );
              },
              onReorder:  (int oldIndex, int newIndex) => state.onChangedSeq(newIndex, oldIndex),
            )
          ],
        ),
      )
    );
  }
}

class SuggestionTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final int index;
  final Function(String?, int) onChanged;

  SuggestionTextField({super.key, required this.textEditingController, required this.index, required this.onChanged});

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  String editingValue = "";
  String currentWord = "";

  @override
  void initState() {
    editingValue = widget.textEditingController.text;
    widget.textEditingController.addListener(() {
      if (widget.textEditingController.selection.base.offset > 0 &&
          editingValue != widget.textEditingController.text) {
        String currentLetter = widget.textEditingController.text.substring(
            widget.textEditingController.selection.base.offset - 1,
            widget.textEditingController.selection.base.offset);
        if(currentLetter == " ") {
          currentWord = "";
        } else if (editingValue.length > widget.textEditingController.text.length && currentWord.isNotEmpty){
          currentWord = currentWord.substring(0, currentWord.length - 1);
        }  else {
          currentWord = currentWord + currentLetter;
        }
      }
      editingValue = widget.textEditingController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          enabledBorder: InputBorder.none
      ),
      controller: widget.textEditingController,
      onChanged: (String? val) => widget.onChanged(val, widget.index),
    );
  }
}
