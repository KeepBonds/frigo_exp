import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../objects/Recipe.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  double multiplicateur = 1.0;
  double? customMultiplicateur;

  List<double> multiList = [
    0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0
  ];

  Recipe get recipe => widget.recipe;

  onTapMinus() {
    customMultiplicateur = null;
    int index = multiList.indexOf(multiplicateur);
    if(index == 0) return;
    setState(() {
      multiplicateur = multiList[index-1];
    });
  }

  onTapPlus() {
    customMultiplicateur = null;
    int index = multiList.indexOf(multiplicateur);
    if(index == multiList.length-1) return;
    setState(() {
      multiplicateur = multiList[index+1];
    });
  }

  onChangeCustomMultiplicateur() {
    showDialog(context: context, builder: (context) {
      return Dialog(
        child: TextField(
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          onChanged: (t) {
            customMultiplicateur = double.tryParse(t);
          },
        ),
      );
    }).then((value) {
      setState(() {});
    });
  }

  onUploadImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? imagePicked = await picker.pickImage(source: ImageSource.gallery);
    File? file = await cropFile(imagePicked);
    if(file != null) {
      recipe.saveImageApi(file);
    }
    setState(() {});
  }

  Future<File?> cropFile(XFile? imagePicked) async {
    if(imagePicked == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePicked.path,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio5x4
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true
        ),
        IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true
        )
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  String getImageUrl() {
    String imageUrl = "";
    if(recipe.image.isNotEmpty) {
      imageUrl = "https://www.ragic.com/sims/file.jsp?a=acdu92&f=${Uri.encodeQueryComponent(recipe.image)}";
    }
    return imageUrl;
  }

  String getDosage(Ingredient ingredient) {
    return (ingredient.dosage * (customMultiplicateur ?? multiplicateur)).toString();
  }

  Widget displayImage() {
    String imageUrl = getImageUrl();
    if(imageUrl.isEmpty) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      child: CachedNetworkImage(
        fit: BoxFit.fitWidth,
        imageUrl: imageUrl,
        httpHeaders: const {"Authorization" : "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA=="},
        errorWidget: (BuildContext context, String error, dynamic stackTrace) {
          return Container();
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child:  Text(recipe.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera_outlined),
            onPressed: onUploadImage,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(recipe.ingredients.isNotEmpty)
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                            child: Row(
                              children: [
                                const Text("Multiplicateur:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                                InkWell(
                                  onTap: onTapMinus,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: Text("-"),
                                  ),
                                ),
                                InkWell(
                                  onTap: onChangeCustomMultiplicateur,
                                  child: Text((customMultiplicateur ?? multiplicateur).toString()),
                                ),
                                InkWell(
                                  onTap: onTapPlus,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: Text("+"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: displayImage()
                        )
                    ],
                  ),
                  if(recipe.ingredients.isNotEmpty) Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                    child: const Text("Ingredient:", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  ),
                  for(int i = 0 ; i < recipe.ingredients.length ; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 4.0),
                      child: Text("• ${recipe.ingredients[i].name} - ${getDosage(recipe.ingredients[i])} ${recipe.ingredients[i].measure.name}"),
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
          ],
        ),
      ),
    );
  }
}
