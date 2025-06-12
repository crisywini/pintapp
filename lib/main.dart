import 'package:flutter/material.dart';
import 'package:pintapp/presentation/screens/menu_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PintApp',
      home: Scaffold(
        appBar: AppBar(title: const Text("PintApp")),
        body: const Center(child: MenuScreen()),
      ),
    );
  }
}
