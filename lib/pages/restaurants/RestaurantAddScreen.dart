import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frigo_exp/manager/manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../elements/elements.dart';
import '../../objects/objects.dart';

class RestaurantAddScreen extends StatefulWidget {
  final Restaurant? restaurant;
  const RestaurantAddScreen({super.key, this.restaurant});

  @override
  _RestaurantAddScreenState createState() => _RestaurantAddScreenState();
}

class _RestaurantAddScreenState extends State<RestaurantAddScreen> {

  late TextEditingController nameController;
  late TextEditingController addressController;

  List<dynamic> pictures = [];

  @override
  void initState() {

    print(widget.restaurant?.ragicId ?? "null");
    nameController = TextEditingController(text: widget.restaurant?.name ?? "");
    addressController = TextEditingController(text: widget.restaurant?.location ?? "");

    if(widget.restaurant?.image != null && widget.restaurant!.image.isNotEmpty) {
      for(String image in widget.restaurant!.image) {
        pictures.add(image);
      }
    }
    super.initState();
  }

  Future<void> onAddMenuPicture() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> files = await picker.pickMultiImage();

    if(files.isNotEmpty) {
      for(XFile file in files) {
        pictures.add(File(file.path));
      }
    }
    setState(() {});
  }

  Future<void> onSaveRestaurant() async {
    await RestaurantManager.getState().saveToApi(widget.restaurant, nameController.text, addressController.text, pictures);
    Navigator.pop(context);
  }

  Widget displayImage(dynamic pic) {
    if(pic is File) {
      return Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(pic.path))
          )
        ),
      );
    }
    if(pic is String) {
      return CachedNetworkImage(
        imageUrl: "https://www.ragic.com/sims/file.jsp?a=acdu92&f=$pic",
        httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
        progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress,) {
          return const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (BuildContext context, String error, dynamic stackTrace) {
          return Container();
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.restaurant != null ? "Edit" : "Add restaurant", style: const TextStyle(color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: onSaveRestaurant,
              icon: const Icon(Icons.check, color: Colors.black87,)
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Restaurant name:"
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address"
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Menu"),
                  TextButton(onPressed: onAddMenuPicture, child: const Text("Add"))
                ],
              ),
              MenuEditCarousel(images: pictures,),
            ],
          ),
        ),
      ),
    );
  }
}


class MenuEditCarousel extends StatefulWidget {
  final List<dynamic> images;

  const MenuEditCarousel({Key? key, required this.images}) : super(key: key);

  @override
  State<MenuEditCarousel> createState() => _MenuEditCarouselState();
}

class _MenuEditCarouselState extends State<MenuEditCarousel> {
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
    if(widget.images.isEmpty) {
      return Container();
    }
    return SizedBox(
        height: 6.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.map((url) {
              int index = widget.images.indexOf(url);
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
          items: List<int>.generate(widget.images.length, (index) => index).map((i) {
            return Builder(
              builder: (BuildContext context) {
                if(widget.images[i] is File) {
                  return Container(
                    constraints: const BoxConstraints(minHeight: 200),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(widget.images[i].path))
                        )
                    ),
                  );
                }
                return CachedNetworkImage(
                  imageUrl: getImageUrl(widget.images[i]),
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