import 'package:ai_recipe_generator/core/constants/app_constants.dart';
import 'package:ai_recipe_generator/core/theme/app_theme.dart';
import 'package:ai_recipe_generator/data/models/recipe_model.dart';
import 'package:ai_recipe_generator/presentation/screens/splash_screen.dart';
import 'package:ai_recipe_generator/presentation/providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter()); // Need to generate this
  await Hive.openBox<RecipeModel>(AppConstants.favoritesBox);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
