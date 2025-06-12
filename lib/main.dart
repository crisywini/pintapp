import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PintApp',
      home: Scaffold(
        appBar: AppBar(title: const Text('PintApp')),
        body: Center(child: const Text('App')),
      ),
    );
  }
}
