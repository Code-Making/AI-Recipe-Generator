import '../repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';

class ToggleFavoriteUseCase {
  final RecipeRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(RecipeModel recipe) async {
    final isFav = repository.isFavorite(recipe);
    if (isFav) {
      await repository.removeFavorite(recipe);
    } else {
      await repository.addFavorite(recipe);
    }
  }

  bool isFavorite(RecipeModel recipe) {
    return repository.isFavorite(recipe);
  }
}
