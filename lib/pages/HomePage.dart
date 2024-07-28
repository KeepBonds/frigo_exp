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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesome.fridge),
            activeIcon: Icon(FontAwesome.fridgeSolid),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesome.knife),
            activeIcon: Icon(FontAwesome.knifeSolid),

          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesome.listCheck),
            activeIcon: Icon(FontAwesome.listCheckSolid),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(FontAwesome.ustensils),
            activeIcon: Icon(FontAwesome.ustensilsSolid),
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        //selectedIconTheme: IconThemeData(
        //  color: appBarMainTheme,
        //),
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: onItemTapped,
      ),
      floatingActionButton: _getFloatingActionButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


