import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';
import '../widgets/custom_app_bar.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Favorites'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              style: GoogleFonts.cairo(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                hintStyle: GoogleFonts.cairo(color: Colors.grey),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 255, 119, 0)),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E1E)
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: favorites.when(
              data: (recipes) {
                final filteredRecipes = recipes
                    .where((r) => r.name.toLowerCase().contains(_searchQuery))
                    .toList();

                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 64, color: Colors.grey[800]),
                        const SizedBox(height: 16),
                        Text(
                          "No favorites yet!",
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Text(
                      "No matches found.",
                      style: GoogleFonts.cairo(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white, // Adapted
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.2 : 0.05),
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
                                // Top Row: Cuisine Tag & Difficulty & Delete Function
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
                                    Row(
                                      children: [
                                        Text(
                                          recipe.difficulty,
                                          style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.grey[500]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Delete Button
                                        InkWell(
                                          onTap: () {
                                            _showDeleteConfirmation(
                                                context, recipe);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red[300],
                                            size: 20,
                                          ),
                                        ),
                                      ],
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
                                    color:
                                        isDark ? Colors.white : Colors.black87,
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
                    ).animate().fadeIn(delay: (50 * index).ms).slideX();
                  },
                );
              },
              error: (err, st) => Center(child: Text("Error: $err")),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withOpacity(0.1))),
          title: Text(
            "Remove from Favorites?",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to remove '${recipe.name}' from your favorites?",
            style: GoogleFonts.cairo(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: GoogleFonts.cairo(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(recipe);
                Navigator.of(context).pop();
              },
              child: Text(
                "Remove",
                style: GoogleFonts.cairo(
                    color: Colors.red[400], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
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
