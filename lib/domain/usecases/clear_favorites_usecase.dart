import '../repositories/recipe_repository.dart';

class ClearFavoritesUseCase {
  final RecipeRepository repository;

  ClearFavoritesUseCase(this.repository);

  Future<void> call() async {
    await repository.clearFavorites();
  }
}
