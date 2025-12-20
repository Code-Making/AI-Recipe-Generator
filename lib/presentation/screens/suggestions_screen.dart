import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/recipe_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'recipe_detail_screen.dart';

class SuggestionsScreen extends ConsumerStatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  ConsumerState<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends ConsumerState<SuggestionsScreen> {
  @override
  void initState() {
    super.initState();
    // Optional: Auto-fetch if data is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSuggestions();
    });
  }

  void _fetchSuggestions() {
    final lastIngredients = ref.read(lastIngredientsProvider);
    if (lastIngredients.isNotEmpty) {
      final cuisine = ref.read(selectedCuisineProvider);
      final calories = ref.read(selectedCaloriesProvider);
      ref.read(suggestedRecipesProvider.notifier).generateSuggestions(
            lastIngredients,
            cuisine,
            calories,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastIngredients = ref.watch(lastIngredientsProvider);
    final suggestionsState = ref.watch(suggestedRecipesProvider);

    // Listen for changes in ingredients to auto-fetch
    ref.listen(lastIngredientsProvider, (previous, next) {
      if (next.isNotEmpty && next != previous) {
        // Use a microtask to avoid building while building
        Future.microtask(() => _fetchSuggestions());
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI Suggestions'),
      body: lastIngredients.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No suggestions yet!",
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Generate a recipe on the Home screen\nto unlock personalized suggestions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ).animate().fadeIn(),
            )
          : suggestionsState.when(
              data: (recipes) {
                if (recipes.isEmpty) {
                  // Should essentially be loading state if logic is correct, but handles empty return
                  return Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: recipes.length + 1, // +1 for "Why this?" header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF2C1B10), // Very dark orange/brown tint
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.orange.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome,
                                      color: Colors.orange[700], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Why these suggestions?",
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.orange[100],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Based on your last ingredients ($lastIngredients), cuisine preference, and calorie goals.",
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.orange[50]?.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().slideY(),
                      );
                    }

                    final recipe = recipes[index - 1];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), // Dark card surface
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.05)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Row: Cuisine Tag & Difficulty
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        recipe.cuisine,
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      recipe.difficulty,
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Recipe Name
                                Text(
                                  recipe.name,
                                  style: GoogleFonts.cairo(
                                    fontSize: 20, // Prominent title
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Footer Row: Time & Calories
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      Icons.access_time_filled_rounded,
                                      "${recipe.prepTime} min",
                                      Colors.blueGrey[300]!,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildInfoChip(
                                      Icons.local_fire_department_rounded,
                                      "${recipe.calories} Kcal",
                                      Colors.orange[400]!,
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (100 * index).ms).slideX();
                  },
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      "Thinking of suggestions...",
                      style: GoogleFonts.cairo(fontSize: 16),
                    ).animate().fadeIn(),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Couldn't get suggestions",
                        style: GoogleFonts.cairo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please try again later.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchSuggestions,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: lastIngredients.isNotEmpty
          ? FloatingActionButton(
              onPressed: _fetchSuggestions,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.refresh, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.grey[400],
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
