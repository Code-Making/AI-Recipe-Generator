import '../../domain/repositories/recipe_repository.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  @override
  Future<List<RecipeModel>> generateRecipes(
      String ingredients, String cuisine, int? calories) async {
    return await remoteDataSource.generateRecipes(
        ingredients, cuisine, calories);
  }

  @override
  Future<List<RecipeModel>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(RecipeModel recipe) async {
    await localDataSource.addFavorite(recipe);
  }

  @override
  Future<void> removeFavorite(RecipeModel recipe) async {
    await localDataSource.removeFavorite(recipe);
  }

  @override
  bool isFavorite(RecipeModel recipe) {
    return localDataSource.isFavorite(recipe);
  }

  @override
  Future<void> clearFavorites() async {
    await localDataSource.clearFavorites();
  }
}
