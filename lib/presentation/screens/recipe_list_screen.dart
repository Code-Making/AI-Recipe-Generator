import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(generatedRecipesProvider);

    final cuisineFlags = {
      'Turkish': '🇹🇷',
      'Arabic': '🇸🇦',
      'Italian': '🇮🇹',
      'Indian': '🇮🇳',
      'Mexican': '🇲🇽',
      'Chinese': '🇨🇳',
      'Japanese': '🇯🇵',
      'French': '🇫🇷',
      'American': '🇺🇸',
      'Any': '🌍',
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Generated Recipes")),
      body: state.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
                child: Text("No recipes found. Try different ingredients!"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final flag = cuisineFlags[recipe.cuisine] ?? '🥘';
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  title: Text(
                    recipe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Text("$flag ${recipe.cuisine} • ${recipe.prepTime} min"),
                      const SizedBox(width: 8),
                      Icon(Icons.local_fire_department,
                          size: 16, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text("${recipe.calories} kcal"),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ).animate().slideX(delay: 50.ms * index);
            },
          );
        },
        error: (err, st) => Center(child: Text("Error: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
