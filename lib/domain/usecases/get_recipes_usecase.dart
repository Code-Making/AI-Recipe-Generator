import '../repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<List<RecipeModel>> call(
      String ingredients, String cuisine, int? calories) {
    return repository.generateRecipes(ingredients, cuisine, calories);
  }
}
