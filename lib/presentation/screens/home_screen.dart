import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../providers/recipe_provider.dart';
import 'recipe_list_screen.dart';

import 'loading_screen.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _ingredientsController = TextEditingController();

  void _generateRecipes() async {
    final ingredients = _ingredientsController.text.trim();
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Please enter specific ingredients!',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(20),
          elevation: 4,
        ),
      );
      return;
    }

    final cuisine = ref.read(selectedCuisineProvider);
    final calories = ref.read(selectedCaloriesProvider);

    // Show Loading Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoadingScreen()),
    );

    // Trigger generation (min delay to show animation)
    final minDelay = Future.delayed(const Duration(seconds: 4));

    // Save for suggestions
    ref.read(lastIngredientsProvider.notifier).set(ingredients);

    final generationParams = ref
        .read(generatedRecipesProvider.notifier)
        .generate(ingredients, cuisine, calories);

    await Future.wait([minDelay, generationParams]);

    // Navigate to results
    if (mounted) {
      // Replace Loading Screen with Result List
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RecipeListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCuisine = ref.watch(selectedCuisineProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: AppConstants.appName),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.8),
                    theme.primaryColor.withOpacity(0.4)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  // Image on Left
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/home_banner.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ).animate().scale(delay: 200.ms),
                  const SizedBox(width: 8),
                  // Text on Right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's in your\nkitchen?",
                          style: GoogleFonts.cairo(
                            fontSize: 26, // Reduced slightly to fit
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ).animate().fadeIn().moveX(begin: 20, end: 0),
                        const SizedBox(height: 4),
                        Text(
                          "We'll help you cook something amazing.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Ingredients",
                    style: GoogleFonts.cairo(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _ingredientsController,
                    decoration: InputDecoration(
                      hintText: "e.g. Chicken, Tomato, Rice",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.primaryColor),
                      ),
                      prefixIcon: const Icon(Icons.shopping_basket_outlined),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 3,
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 20),
                  // Side-by-Side Filter Cards
                  Row(
                    children: [
                      // Cuisine Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1A1A1A), // Dark card background
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.restaurant_menu,
                                      color: Colors.orange[700], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Cuisine",
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedCuisine == 'Any'
                                    ? "All Cuisines"
                                    : selectedCuisine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          theme.scaffoldBackgroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24)),
                                      ),
                                      builder: (context) => Container(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Select Cuisine",
                                              style: GoogleFonts.cairo(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              alignment: WrapAlignment.center,
                                              children: AppConstants.cuisines
                                                  .map((cuisine) {
                                                final isSelected =
                                                    selectedCuisine == cuisine;
                                                return ChoiceChip(
                                                  label: Text(cuisine),
                                                  selected: isSelected,
                                                  selectedColor:
                                                      theme.primaryColor,
                                                  backgroundColor:
                                                      theme.cardColor,
                                                  labelStyle: TextStyle(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : theme.textTheme
                                                            .bodyMedium?.color,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    side: BorderSide(
                                                      color: isSelected
                                                          ? Colors.transparent
                                                          : Colors.grey
                                                              .withOpacity(0.2),
                                                    ),
                                                  ),
                                                  onSelected: (selected) {
                                                    if (selected) {
                                                      ref
                                                          .read(
                                                              selectedCuisineProvider
                                                                  .notifier)
                                                          .set(cuisine);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 24),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[800],
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.orange.withOpacity(0.4),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  child: const Text("Choose",
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Calories Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1A1A1A), // Dark card background
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_fire_department_rounded,
                                      color: Colors.orange[700], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Calories",
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "${ref.watch(selectedCaloriesProvider) ?? 2000} Kcal",
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          theme.scaffoldBackgroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24)),
                                      ),
                                      builder: (context) => Consumer(
                                        builder: (context, ref, child) {
                                          final calories = ref.watch(
                                                  selectedCaloriesProvider) ??
                                              2000;
                                          return Container(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  "Select Max Calories",
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  "$calories Kcal",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.primaryColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 24),
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    trackHeight: 8,
                                                    activeTrackColor:
                                                        theme.primaryColor,
                                                    inactiveTrackColor: theme
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    thumbColor: Colors.white,
                                                    overlayColor: theme
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                12,
                                                            elevation: 4),
                                                  ),
                                                  child: Slider(
                                                    value: calories.toDouble(),
                                                    min: 100,
                                                    max: 2000,
                                                    divisions: 19,
                                                    label: "$calories Kcal",
                                                    onChanged: (value) {
                                                      ref
                                                          .read(
                                                              selectedCaloriesProvider
                                                                  .notifier)
                                                          .set(value.toInt());
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[800],
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.orange.withOpacity(0.4),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  child: const Text("Choose",
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 234, 110, 1),
                            Color.fromARGB(255, 255, 136, 0)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6D00).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _generateRecipes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/home_banner.png',
                              height: 34, // 👈 أصغر (مهم)
                              width: 34,
                            ),
                            const SizedBox(width: 2), // 👈 مسافة قريبة جدًا
                            Text(
                              "Generate Recipes",
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1, // 👈 يقلل الفراغ العمودي
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: 100), // Spacing for floating NavBar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
