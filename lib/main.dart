import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: HomeCookApp()));
}

class HomeCookApp extends StatelessWidget {
  const HomeCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Home Cook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const featureAreas = <String>[
    'Pantry Management',
    'Recipe Library',
    'Meal Planning',
    'Shopping List',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Home Cook'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your kitchen companion for pantry tracking, recipes, and meal planning.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Core Feature Areas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...featureAreas.map(
            (feature) => ListTile(
              key: Key('feature-$feature'),
              title: Text(feature),
            ),
          ),
        ],
      ),
    );
  }
}
