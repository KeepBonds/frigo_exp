import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../manager/manager.dart';
import '../../objects/objects.dart';
import '../../elements/elements.dart';
import 'RecipeScreen.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  _RecipePageController createState() => _RecipePageController();
}
class _RecipePageController extends State<RecipePage> {
  MealType? mealTypeFiler;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList({bool force = false}) async {
    await RecipeManager.getState().loadRecipesFromApi(force: force);
    if(mounted) {
      setState(() {});
    }
  }

  Future<void> onRefresh() async {
    await loadList(force: true);
  }

  onPressedFilter(MealType type) {
    if(mealTypeFiler == type) {
      mealTypeFiler = null;
    } else {
      mealTypeFiler = type;
    }
    setState(() {});
  }

  onClearFilter() {
    RecipeManager.getState().clearItemFilter();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => _RecipePageView(this);
}
class _RecipePageView extends WidgetView<RecipePage, _RecipePageController> {
  _RecipePageView(_RecipePageController state) : super(state);

  List<Widget> filterChipList() {
    if(RecipeManager.getState().isItemFiltered) {
      return [
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: RecipeManager.getState().isItemFiltered,
          text: RecipeManager.getState().itemFilter!.name,
          icon: Icons.clear,
          assetName: RecipeManager.getState().itemFilter!.assetName,
          onTap: state.onClearFilter,
        ),
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: state.mealTypeFiler == MealType.PtitDej,
          text: "",
          icon: Icons.coffee,
          onTap: () => state.onPressedFilter(MealType.PtitDej),
        ),
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: state.mealTypeFiler == MealType.Repas,
          text: "",
          icon: Icons.lunch_dining,
          onTap: () => state.onPressedFilter(MealType.Repas),
        ),
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: state.mealTypeFiler == MealType.Dessert,
          text: "",
          icon: Icons.icecream,
          onTap: () => state.onPressedFilter(MealType.Dessert),
        ),
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: state.mealTypeFiler == MealType.Drinks,
          text: "",
          icon: Icons.water_drop_outlined,
          onTap: () => state.onPressedFilter(MealType.Dessert),
        ),
        const SizedBox(width: 8.0,),
        RecipeChipFilter(
          selected: state.mealTypeFiler == MealType.Test,
          text: "",
          icon: Icons.question_mark,
          onTap: () => state.onPressedFilter(MealType.Dessert),
        ),
        const SizedBox(width: 8.0,),
      ];
    }
    return [
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.PtitDej,
        text: "Breakfast",
        icon: Icons.coffee,
        onTap: () => state.onPressedFilter(MealType.PtitDej),
      ),
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.Repas,
        text: "Meal",
        icon: Icons.dinner_dining,
        onTap: () => state.onPressedFilter(MealType.Repas),
      ),
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.Dessert,
        text: "Dessert",
        icon: Icons.icecream,
        onTap: () => state.onPressedFilter(MealType.Dessert),
      ),
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.Drinks,
        text: "Drinks",
        icon: Icons.water_drop_outlined,
        onTap: () => state.onPressedFilter(MealType.Drinks),
      ),
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.Prep,
        text: "Meal Prep",
        icon: Icons.lunch_dining,
        onTap: () => state.onPressedFilter(MealType.Prep),
      ),
      const SizedBox(width: 8.0,),
      RecipeChipFilter(
        selected: state.mealTypeFiler == MealType.Test,
        text: "Test",
        icon: Icons.question_mark,
        onTap: () => state.onPressedFilter(MealType.Test),
      ),
      const SizedBox(width: 8.0,),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8.0,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: filterChipList(),
            ),
          ),
          const SizedBox(height: 8.0,),
          Expanded(
              child: RefreshIndicator(
                onRefresh: state.onRefresh,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                      ),
                      itemCount: RecipeManager.getState().getRecipes(state.mealTypeFiler).length,
                      itemBuilder: (context, index) {
                        return OpenContainer(
                          transitionType: ContainerTransitionType.fade,
                          openBuilder: (BuildContext _, VoidCallback openContainer) {
                            return RecipeScreen(recipe: RecipeManager.getState().getRecipes(state.mealTypeFiler)[index]);
                          },
                          closedElevation: 0.0,
                          closedBuilder: (BuildContext _, VoidCallback openContainer) {
                            Recipe recipe = RecipeManager.getState().getRecipes(state.mealTypeFiler)[index];
                            String imageUrl = "";
                            if(recipe.image.isNotEmpty) {
                              imageUrl = "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(recipe.image)}";
                            }
                            return Card(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      imageUrl.isEmpty ? Container() : Flexible(
                                        child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                          child: CachedNetworkImage(
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fitWidth,
                                            imageUrl: imageUrl,
                                            httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
                                            errorWidget: (BuildContext context, String error, dynamic stackTrace) {
                                              return Container();
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(recipe.name, textAlign: TextAlign.center,),
                                      )
                                    ],
                                  ),
                                )
                            );
                          },
                        );
                      }
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}


class RecipeChipFilter extends StatelessWidget {
  final bool selected;
  final String text;
  final IconData icon;
  final String? assetName;
  final Function() onTap;

  const RecipeChipFilter({super.key, required this.selected, required this.text, this.assetName, required this.icon, required this.onTap});

  TextStyle get unSelectedTextStyle => const TextStyle(color: Colors.black87);
  TextStyle get selectedTextStyle => const TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onTap,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: selected ? Colors.red : Colors.black87)
        ),
        label: Row(
          children: [
            if(assetName != null) Container(
              padding: const EdgeInsets.only(right: 4.0),
              child: Image(
                height: 20,
                image: AssetImage(assetName!),
              ),
            ),
            if(text.isNotEmpty) Text(text, style: selected ? selectedTextStyle : unSelectedTextStyle,),
            if(text.isNotEmpty) const SizedBox(width: 8.0,),
            Icon(icon, color: selected ? Colors.red : Colors.black87,),
          ],
        ),
      ),
    );
  }
}
