import '../../data/models/recipe_model.dart'; // Ideally Domain entity, but for simplicity we use Model here.

abstract class RecipeRepository {
  Future<List<RecipeModel>> generateRecipes(
      String ingredients, String cuisine, int? calories);
  Future<List<RecipeModel>> getFavorites();
  Future<void> addFavorite(RecipeModel recipe);
  Future<void> removeFavorite(RecipeModel recipe);
  Future<void> clearFavorites();
  bool isFavorite(RecipeModel recipe);
}
