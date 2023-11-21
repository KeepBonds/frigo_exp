import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../elements/elements.dart';
import '../manager/manager.dart';
import '../objects/objects.dart';
import 'RestaurantAddScreen.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  _RestaurantPageController createState() => _RestaurantPageController();
}
class _RestaurantPageController extends State<RestaurantPage> {
  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList() async {
    await RestaurantManager.getState().loadRestaurantsFromApi();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) => _RestaurantPageView(this);
}

class _RestaurantPageView extends WidgetView<RestaurantPage, _RestaurantPageController> {
  const _RestaurantPageView(_RestaurantPageController state) : super(state);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // FILTERS
            ],
          ),
          Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                  ),
                  itemCount: RestaurantManager.getState().restaurant.length,
                  itemBuilder: (context, index) {
                    //if(FILTER) return Container();
                    return OpenContainer(
                      transitionType: ContainerTransitionType.fade,
                      openBuilder: (BuildContext _, VoidCallback openContainer) {
                        return RestaurantScreen(restaurant: RestaurantManager.getState().restaurant[index]);
                      },
                      closedElevation: 0.0,
                      closedBuilder: (BuildContext _, VoidCallback openContainer) {
                        return ListTile(
                          title: Text(RestaurantManager.getState().restaurant[index].name),
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

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantScreen({Key? key, required this.restaurant}) : super(key: key);

  String getImageUrl(image) {
    return "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(image)}";
  }

  editRestaurant(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RestaurantAddScreen(restaurant: restaurant,)),
    );
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
                  const SizedBox(height: 12.0,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child:  Text(restaurant.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 12.0,),
                  if(restaurant.location.isNotEmpty) Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Location:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                            Text(restaurant.location, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                          ],
                        ),
                        const Icon(Icons.map_outlined),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child:  const Text("Images:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  ),
                  MenuCarousel(restaurant: restaurant,)
                  //for(String menuImage in restaurant.image)
                  //  CachedNetworkImage(
                  //    imageUrl: getImageUrl(menuImage),
                  //    httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
                  //    errorWidget: (BuildContext context, String error, dynamic stackTrace) {
                  //      return Container();
                  //    },
                  //  ),
                ],
              ),
            ),
            Positioned(
                right: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => editRestaurant(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCarousel extends StatefulWidget {
  final Restaurant restaurant;

  const MenuCarousel({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<MenuCarousel> createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel> {
  int pageIndex = 0;

  onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      pageIndex = index;
    });
  }

  String getImageUrl(image) {
    return "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(image)}";
  }

  Widget pageIndicator() {
    if(widget.restaurant.image.isEmpty) {
      return Container();
    }
    return SizedBox(
        height: 6.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.restaurant.image.map((url) {
              int index = widget.restaurant.image.indexOf(url);
              return Container(
                margin: const EdgeInsets.only(right: 2.0, left: 2.0, top: 8.0),
                child: Icon(
                  Icons.circle,
                  size: 6.0,
                  color: pageIndex == index
                      ? const Color.fromRGBO(0, 0, 0, 0.9)
                      : const Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 400.0,
              enableInfiniteScroll: false,
              onPageChanged: onCarouselPageChanged
          ),
          items: List<int>.generate(widget.restaurant.image.length, (index) => index).map((i) {
            return Builder(
              builder: (BuildContext context) {
                return CachedNetworkImage(
                  imageUrl: getImageUrl(widget.restaurant.image[i]),
                  httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
                  errorWidget: (BuildContext context, String error, dynamic stackTrace) {
                    return Container();
                  },
                  progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress,) {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
        pageIndicator(),
      ],
    );
  }
}
