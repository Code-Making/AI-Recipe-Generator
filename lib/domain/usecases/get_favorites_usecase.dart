import '../repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';

class GetFavoritesUseCase {
  final RecipeRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<RecipeModel>> call() {
    return repository.getFavorites();
  }
}
