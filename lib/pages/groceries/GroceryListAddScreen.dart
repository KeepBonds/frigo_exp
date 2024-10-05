import 'package:flutter/services.dart';
import '../../Constants.dart';
import '../../manager/manager.dart';
import '../../elements/elements.dart';
import '../../objects/objects.dart';

class GroceryItemController {
  GroceryItem item;
  TextEditingController controller;
  FocusNode focusNode;

  GroceryItemController(this.item, this.controller, this.focusNode);

  @override
  String toString() {
    return "|${item.name}, ${item.ragicId}, ${item.seq}, ${controller.text}|\n";
  }
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

  late ScrollController scrollController;

  List<GroceryItem> items = [];
  List<GroceryItemController> controllers = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    nameController = TextEditingController(text: widget.groceryList != null ? widget.groceryList!.name : "");

    if(widget.groceryList != null) {
      //items = List.from(widget.groceryList!.items);
      items = widget.groceryList!.items.map((item) => GroceryItem.copy(item)).toList();

      items.sort((a, b) => a.seq.compareTo(b.seq));
    }

    const String invisibleChar = '\u200B';
    for(GroceryItem item in items) {
      controllers.add(GroceryItemController(item, TextEditingController(text: invisibleChar + item.name), FocusNode()));
    }

    controllers.add(GroceryItemController(GroceryItem.create(controllers.length), TextEditingController(text: invisibleChar), FocusNode()));
  }

  onChanged(String? val, int index) {
    print(controllers.toString());

    if(val == null) return;
    print("VAL:" + val + "|  SS? | " + val.length.toString()  );
    if(val.contains("\n")) {
      controllers[index].item.name = val.replaceAll("\n", "");
      controllers[index].controller.text = val.replaceAll("\n", "");
      onAddNewLine(val.replaceAll("\n", ""), index);
      controllers[index+1].focusNode.requestFocus();
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
      controllers[index].item.name = val;
    }
    setState(() {});
  }

  onAddNewLine(val, index) {
    int newLineIndex = index;
    print("NEW INDEX  = " + (index + 1).toString());
    if(index == controllers.length - 1) {
      newLineIndex = index + 1;
    } else {
      newLineIndex = index + 1;
      print("NEW INDEX 2 $index - ${controllers.length}");

      for(int i = index ; i < controllers.length ; i++) {
        controllers[i].item.seq = controllers[i].item.seq + 1;
      }
      // for(GroceryItemController gc in controllers) {
      //  gc.item.seq = gc.item.seq+1;
      //}
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
      controllers.add(GroceryItemController(GroceryItem.create(controllers[index].item.seq+1), TextEditingController(text: invisibleChar), FocusNode()));
    } else {
      controllers.insert(newLineIndex, GroceryItemController(GroceryItem.create(controllers[index].item.seq+1), TextEditingController(text: invisibleChar), FocusNode()));
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

  onSave() async {
    String name = nameController.text;

    List<GroceryItem> saveItems = [];
    for(GroceryItemController controller in controllers) {
      if(controller.item.ragicId == -100000000 || controller.controller.text == '\u200B') continue;
      saveItems.add(controller.item);
    }

    if(widget.groceryList != null) {
      List<FridgeProduct> addProductList = await addToFridge(widget.groceryList, saveItems);
      List<GroceryItem> deletedItems = deletedToFridge(saveItems);
      await GroceryListManager.getState().saveListToApi(widget.groceryList, name, saveItems, deletedItems);
      await confirmAddToFridge(addProductList);
    } else {
      List<FridgeProduct> addProductList = await addToFridge(null, saveItems);
      await GroceryListManager.getState().saveListToApi(null, name, saveItems, []);
      await confirmAddToFridge(addProductList);
    }
    Navigator.pop(context);
  }

  Future<void> confirmAddToFridge(List<FridgeProduct> addProductList) async {
    if(addProductList.isNotEmpty) {
      bool confirmAdd = await showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Add to Fridge ?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(FridgeProduct p in addProductList) ListTile(title: Text(p.name), leading: Image(image: AssetImage(p.assetName),),),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          ],
        );
      });
      if(confirmAdd) {
        FridgeManager.getState().addProducts(addProductList);
      }
    }
  }

  Future<List<FridgeProduct>> addToFridge(GroceryList? groceryList, List<GroceryItem> saveItems) async {
    List<FridgeProduct> products = getList();
    List<FridgeProduct> addProductList = [];

    // check if item was not checked and is now checked
    for(GroceryItem item in saveItems) {
      bool add = false;
      if(widget.groceryList != null) {
        List<GroceryItem> iteItem = widget.groceryList!.items.where((element) => element.ragicId == item.ragicId).toList();
        if(iteItem.isNotEmpty && !iteItem.first.checked && item.checked) {
          add = true;
        }
      } else if(groceryList == null && item.checked) {
        add = true;
      }
      if(add) {
        //List<FridgeProduct> prodMatch = products.where((prod) => prod.name == item.name).toList();
        List<FridgeProduct> prodMatch = products.where((prod) {
          return prod.name == item.name.replaceAll('\u200B', "");
        }).toList();
        if(prodMatch.isNotEmpty) {
          addProductList.add(prodMatch.first);
        }
      }
    }
    return addProductList;
  }

  List<GroceryItem> deletedToFridge(List<GroceryItem> saveItems) {
    if(widget.groceryList == null) return [];

    // check if item was not checked and is now checked
    List<GroceryItem> deleteProductList = [];
    for(GroceryItem item in widget.groceryList!.items) {
      if(saveItems.where((element) => element.ragicId == item.ragicId).isEmpty) {
        deleteProductList.add(item);
      }
    }
    return deleteProductList;
  }

  OverlayEntry? _overlayEntry;
  showOverlay(Widget? header) {
    if(header == null) {
      hideOverlay();
      return;
    }
    try{
      _overlayEntry?.remove();
    } catch(e) {}
    OverlayState? os = Overlay.of(context);

    _overlayEntry = OverlayEntry(builder: (context) {
      return KeyboardOverlay(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          hideOverlay();
        },
        header: header,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      os.insert(_overlayEntry!);
    });
  }

  void hideOverlay() {
    if(_overlayEntry == null) {
      return;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void scrollUp() {
    scrollController.animateTo(scrollController.offset + 50, duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn,);
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
          onPressed: () {
            state.hideOverlay();
            Navigator.pop(context);
          }
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
        controller: state.scrollController,
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
                            focusNode: state.controllers[index].focusNode,
                            index: index,
                            checked: state.controllers[index].item.checked,
                            showOverlay: state.showOverlay,
                            hideOverlay: state.hideOverlay,
                            scrollUp: state.scrollUp,
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
  final FocusNode focusNode;
  final int index;
  final bool checked;
  final Function(Widget?) showOverlay;
  final Function() hideOverlay;
  final Function() scrollUp;
  final Function(String?, int) onChanged;

  SuggestionTextField({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.index,
    required this.checked,
    required this.showOverlay,
    required this.hideOverlay,
    required this.scrollUp,
    required this.onChanged
  });

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
      print("Current Word $currentWord && ${currentWord.isEmpty}");
      if(currentWord.isNotEmpty) {
        widget.showOverlay(overLayList());
      } else {
        widget.hideOverlay();
      }
      editingValue = widget.textEditingController.text;
    });

    widget.focusNode.addListener(() {
      if(!widget.focusNode.hasFocus) {
        currentWord = "";
        widget.hideOverlay();
      }
    });
    super.initState();
  }

  Widget? overLayList() {
    List<FridgeProduct> products = getList();

    List<Widget> list = [];
    for (int i = 0; i < products.length; i++) {
      if(products[i].name.toLowerCase().startsWith(currentWord.toLowerCase())) {
        list.add(InkWell(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                alignment: Alignment.center,
                child: Text(
                  products[i].name,
                  style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1)),
                ),),
            onTap: () {
              String newCurrentWord = currentWord;
              currentWord = "";
              String newValue = widget.textEditingController.text.replaceAll(newCurrentWord, products[i].name);
              widget.textEditingController.text = newValue;
              widget.onChanged(newValue, widget.index);
              widget.hideOverlay();
            }
        ));
      }
    }
    if(list.isEmpty) {
      return null;
    }
    return ListView(scrollDirection: Axis.horizontal, children: list);
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
      style: widget.checked ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      onChanged: (String? val) {
        double offset = widget.focusNode.offset.dy;
        final viewInsets = EdgeInsets.fromViewPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio);
        double screenHeight = MediaQuery.of(context).size.height;

        double diff = (screenHeight - offset - 20.0);
        double keyboard = viewInsets.bottom + 50;

        if(diff < keyboard) {
          widget.scrollUp();
        }
        widget.onChanged(val, widget.index);
      }
    );
  }
}


class KeyboardOverlay extends StatelessWidget {
  final Function() onTap;
  final Widget? header;

  const KeyboardOverlay(
      {Key? key, required this.onTap, this.header})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      child: Material(
        child: Column(
          children: <Widget>[
            if(header != null)
              Container(
                  height: 50,
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: header
              ),
          ],
        ),
      ),
    );
  }
}

