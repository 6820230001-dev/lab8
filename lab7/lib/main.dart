import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Lab 7',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          foregroundColor: Colors.white,
        ),
      ),
      home: const Firstpage(),
    );
  }
}

class Firstpage extends ConsumerWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final themeMode = ref.watch(themeProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "จำนวนปัจจุบันคือ:",
              style: TextStyle(
                fontSize: 20,
                color: colors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'minus_btn',
            backgroundColor: Colors.pinkAccent,
            foregroundColor: Colors.white,
            onPressed: () {
              if (ref.read(counterProvider) > 0) {
                ref.read(counterProvider.notifier).state--;
              }
            },
            tooltip: 'ลดจำนวน',
            child: const Icon(Icons.remove, size: 30),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'plus_btn',
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onPressed: () {
              ref.read(counterProvider.notifier).state++;
            },
            tooltip: 'เพิ่มจำนวน',
            child: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
    );
  }
}
