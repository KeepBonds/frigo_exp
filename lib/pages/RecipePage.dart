import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../manager/manager.dart';
import '../objects/objects.dart';
import '../elements/elements.dart';

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

  loadList() async {
    await RecipeManager.getState().loadRecipesFromApi();
    if(mounted) {
      setState(() {});
    }
  }


  onPressedFilter(MealType type) {
    if(mealTypeFiler == type) {
      mealTypeFiler = null;
    } else {
      mealTypeFiler = type;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => _RecipePageView(this);
}
class _RecipePageView extends WidgetView<RecipePage, _RecipePageController> {
  _RecipePageView(_RecipePageController state) : super(state);

  Widget getMealTypeIcon(MealType type) {
    switch(type) {
      case MealType.PtitDej:
        return const Icon(Icons.rice_bowl);
      case MealType.Dessert:
        return const Icon(Icons.icecream);
      case MealType.Repas:
      default:
        return const Icon(Icons.dinner_dining);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => state.onPressedFilter(MealType.PtitDej),
                  icon: Icon(Icons.rice_bowl, color: state.mealTypeFiler == MealType.PtitDej ? Colors.red : Colors.black87,)),
              IconButton(
                  onPressed: () => state.onPressedFilter(MealType.Repas),
                  icon: Icon(Icons.dinner_dining, color: state.mealTypeFiler == MealType.Repas ? Colors.red : Colors.black87,)),
              IconButton(
                  onPressed: () => state.onPressedFilter(MealType.Dessert),
                  icon: Icon(Icons.icecream, color: state.mealTypeFiler == MealType.Dessert ? Colors.red : Colors.black87,)),
            ],
          ),
          Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                ),
                itemCount: RecipeManager.getState().getFilteredRecipes(state.mealTypeFiler).length,
                itemBuilder: (context, index) {
                  return OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (BuildContext _, VoidCallback openContainer) {
                      return RecipeScreen(recipe: RecipeManager.getState().getFilteredRecipes(state.mealTypeFiler)[index]);
                    },
                    closedElevation: 0.0,
                    closedBuilder: (BuildContext _, VoidCallback openContainer) {
                      Recipe recipe = RecipeManager.getState().getFilteredRecipes(state.mealTypeFiler)[index];
                      String imageUrl = "";
                      if(recipe.image.isNotEmpty) {
                        imageUrl = "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(recipe.image)}";
                      }
                      return Card(
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      imageUrl: imageUrl,
                                      httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
                                      errorWidget: (BuildContext context, String error, dynamic stackTrace) {
                                        return Container();
                                      },
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
          ))
        ],
      ),
    );
  }
}

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeScreen({Key? key, required this.recipe}) : super(key: key);

  String getImageUrl() {
    String imageUrl = "";
    if(recipe.image.isNotEmpty) {
      imageUrl = "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(recipe.image)}";
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getImageUrl().isEmpty ? Container() : CachedNetworkImage(
                    height: MediaQuery.of(context).size.width/2,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    imageUrl: getImageUrl(),
                    httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
                    errorWidget: (BuildContext context, String error, dynamic stackTrace) {
                      return Container();
                    },
                  ),
                  const SizedBox(height: 12.0,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child:  Text(recipe.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 12.0,),
                  if(recipe.ingredients.isNotEmpty) Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: const Text("Ingredient:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  ),
                  for(int i = 0 ; i < recipe.ingredients.length ; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 4.0),
                      child: Text("• ${recipe.ingredients[i].name} - ${recipe.ingredients[i].dosage} ${recipe.ingredients[i].measure.name}"),
                    ),
                  if(recipe.steps.isNotEmpty) Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: const Text("Steps:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  ),
                  for(int i = 0 ; i < recipe.steps.length ; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 4.0),
                      child: Text("• ${recipe.steps[i].information}"),
                    ),
                ],
              ),
            ),
            Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
            ),
          ],
        ),
      ),
    );
  }
}