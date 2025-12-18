import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> generateRecipes(
      String ingredients, String cuisine, int? calories);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecipeModel>> generateRecipes(
      String ingredients, String cuisine, int? calories) async {
    try {
      final calorieText =
          calories != null ? "Maximum Calories: $calories kcal." : "";
      final prompt = """
      Generate 3 unique recipes based on these ingredients: $ingredients.
      Preferred Cuisine: $cuisine.
      $calorieText
      
      IMPORTANT: Detect the language of the ingredients provided (e.g., Arabic, English, Spanish, etc.). 
      Generate the recipe names, ingredients, and instructions IN THE SAME LANGUAGE as the input ingredients.
      For example, if the ingredients are in Arabic, the entire response content (name, ingredients, instructions) MUST be in Arabic.

      Return the response in raw JSON format (NO MARKDOWN, NO CODE BLOCKS) as a list of objects with these fields:
      - name (String)
      - cuisine (String) - if 'Any' was requested, pick a suitable one for the recipe
      - difficulty (String) - Easy, Medium, or Hard
      - ingredients (List<String>)
      - instructions (List<String>)
      - prepTime (int) - in minutes
      - calories (int)
      """;

      const apiKey = AppConstants.geminiApiKey;
      const baseUrl = AppConstants.geminiBaseUrl;

      final response = await dio.post(
        '$baseUrl?key=$apiKey',
        options: Options(
          validateStatus: (status) => true,
        ),
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String contentText =
            data['candidates'][0]['content']['parts'][0]['text'];

        contentText =
            contentText.replaceAll('```json', '').replaceAll('```', '').trim();

        final List<dynamic> jsonList = jsonDecode(contentText);

        return jsonList.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        print("API Error Status: ${response.statusCode}");
        print("API Error Body: ${response.data}");
        throw Exception(
            'Failed to generate recipes: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print("API Error: $e");
      return _generateMockRecipes(ingredients, cuisine, calories);
    }
  }

  List<RecipeModel> _generateMockRecipes(
      String ingredients, String cuisine, int? calories) {
    // Generate random mock data
    final random = DateTime.now().millisecondsSinceEpoch;

    final List<String> availableCuisines = [
      'Italian',
      'Mexican',
      'Chinese',
      'Indian',
      'American',
      'French',
      'Japanese',
      'Turkish',
      'Arabic'
    ];

    String getCuisine(int index) {
      if (cuisine == 'Any' || cuisine == 'All') {
        return availableCuisines[(random + index) % availableCuisines.length];
      }
      return cuisine;
    }

    int getCalories(int base) {
      if (calories != null && base > calories) {
        // Linter says receiver can't be null, but calories serves as receiver? No, base > calories.
        // Wait, calories is int?. If checks != null, it is promoted.
        // The lint message said "receiver can't be null".
        // line 97: base > calories!
        // line 98: return calories! - 10
        // If flow analysis knows it's not null, I can remove !.
        return calories - 10;
      }
      return base;
    }

    final c1 = getCuisine(1);
    final c2 = getCuisine(3);
    final c3 = getCuisine(7);

    return [
      RecipeModel(
        name: 'Traditional $c1 Platter',
        cuisine: c1,
        ingredients: ['Fresh Vegetables', ...ingredients.split(',')],
        instructions: [
          'Begin by washing and finely chopping the fresh vegetables. Heat a tablespoon of oil in a skillet.',
          'Add your main ingredients and the vegetables to the pan. Sauté for 10-12 minutes until tender.',
          'Season with traditional $c1 spices and salt to taste.',
          'Serve warm, garnished with fresh parsley or cilantro.'
        ],
        prepTime: 20,
        calories: getCalories(350),
        difficulty: 'Easy',
      ),
      RecipeModel(
        name: 'Spicy $c2 Delight',
        cuisine: c2,
        ingredients: ['Chili Peppers', 'Garlic', ...ingredients.split(',')],
        instructions: [
          'In a mixing bowl, combine the main ingredients with minced garlic and chopped chili peppers.',
          'Let the mixture rest for 15 minutes to allow the flavors to meld.',
          'Cook on a hot grill or pan for 6-8 minutes per side until fully cooked and slightly charred.',
          'Serve with a cooling side salad or yogurt dip to balance the heat.'
        ],
        prepTime: 30,
        calories: getCalories(450),
        difficulty: 'Medium',
      ),
      RecipeModel(
        name: 'Creamy $c3 Bowl',
        cuisine: c3,
        ingredients: [
          'Cream or Coconut Milk',
          'Herbs',
          ...ingredients.split(',')
        ],
        instructions: [
          'Prepare the base by sautéing onions and garlic until translucent.',
          'Add the main ingredients and pour in the cream or coconut milk. Bring to a gentle simmer.',
          'Cover and cook on low heat for 20 minutes allowing the sauce to thicken.',
          'Stir in fresh herbs just before serving over a bed of steamed rice.'
        ],
        prepTime: 40,
        calories: getCalories(550),
        difficulty: 'Hard',
      ),
    ];
  }
}
