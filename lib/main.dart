import 'package:flutter/material.dart';
import 'package:pintapp/presentation/screens/add_item_screen.dart';
import 'package:pintapp/presentation/screens/create_outfit_screen.dart';
import 'package:pintapp/presentation/screens/menu_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/add-item': (context) => AddItemScreen(),
        '/create-outfit': (context) => CreateOutfitScreen(),
      },

      debugShowCheckedModeBanner: false,
      title: 'PintApp',
      home: Scaffold(
        appBar: AppBar(title: const Text("PintApp")),
        body: const Center(child: MenuScreen()),
      ),
    );
  }
}
