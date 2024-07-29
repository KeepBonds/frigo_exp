import 'package:flutter/material.dart';
import 'package:frigo_exp/elements/FontAwesomeIcons.dart';
import 'pages.dart';
import '../manager/manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  loadList() async {
    await FridgeManager.getState().loadSettings();
    setState(() {});
  }

  Future<void> _navigateToAddProducts() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FridgeAddScreen()),
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _navigateToAddGList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GroceryListAddScreen()),
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _navigateToAddRestaurant() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RestaurantAddScreen()),
    ).whenComplete(() {
      setState(() {});
    });
  }

  void onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget? _getFloatingActionButton() {
    if(pageIndex == 0) {
      return FloatingActionButton(
        onPressed: _navigateToAddProducts,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      );
    }
    if(pageIndex == 2) {
      return FloatingActionButton(
        onPressed: _navigateToAddGList,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      );
    }
    if(pageIndex == 3) {
      return FloatingActionButton(
        onPressed: _navigateToAddRestaurant,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        FridgePage(),
        RecipePage(),
        GroceryListPage(),
        RestaurantPage()
      ].elementAt(pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Fridge",
            icon: Icon(FontAwesome.fridge, size: 22,),
            activeIcon: Icon(FontAwesome.fridgeSolid, size: 22),
          ),
          BottomNavigationBarItem(
            label: "Recipe",
            icon: Icon(FontAwesome.knife, size: 22),
            activeIcon: Icon(FontAwesome.knifeSolid, size: 22),
          ),
          BottomNavigationBarItem(
            label: "List",
            icon: Icon(FontAwesome.listCheck, size: 22),
            activeIcon: Icon(FontAwesome.listCheckSolid, size: 22),
          ),
          BottomNavigationBarItem(
            label: "Shops",
            icon: Icon(FontAwesome.ustensils, size: 22),
            activeIcon: Icon(FontAwesome.ustensilsSolid, size: 22),
          ),
        ],
        unselectedIconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        //selectedIconTheme: IconThemeData(
        //  color: appBarMainTheme,
        //),
        currentIndex: pageIndex,
        onTap: onItemTapped,
      ),
      floatingActionButton: _getFloatingActionButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


