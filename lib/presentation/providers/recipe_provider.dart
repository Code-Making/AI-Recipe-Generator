import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/get_recipes_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/clear_favorites_usecase.dart';

part 'recipe_provider.g.dart';

// --- Core Dependencies ---

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(
    baseUrl: AppConstants
        .geminiBaseUrl, // Not strictly used by mock, but good practice
    queryParameters: {'key': AppConstants.geminiApiKey},
  ));
}

@riverpod
Box<RecipeModel> favoritesBox(Ref ref) {
  return Hive.box<RecipeModel>(AppConstants.favoritesBox);
}

// --- Data Sources ---

@riverpod
RecipeRemoteDataSource recipeRemoteDataSource(Ref ref) {
  return RecipeRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
RecipeLocalDataSource recipeLocalDataSource(Ref ref) {
  return RecipeLocalDataSourceImpl(ref.watch(favoritesBoxProvider));
}

// --- Repository ---

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return RecipeRepositoryImpl(
    remoteDataSource: ref.watch(recipeRemoteDataSourceProvider),
    localDataSource: ref.watch(recipeLocalDataSourceProvider),
  );
}

// --- Use Cases ---

@riverpod
GetRecipesUseCase getRecipesUseCase(Ref ref) {
  return GetRecipesUseCase(ref.watch(recipeRepositoryProvider));
}

@riverpod
GetFavoritesUseCase getFavoritesUseCase(Ref ref) {
  return GetFavoritesUseCase(ref.watch(recipeRepositoryProvider));
}

@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(Ref ref) {
  return ToggleFavoriteUseCase(ref.watch(recipeRepositoryProvider));
}

@riverpod
ClearFavoritesUseCase clearFavoritesUseCase(Ref ref) {
  return ClearFavoritesUseCase(ref.watch(recipeRepositoryProvider));
}

// --- Notifiers ---

@riverpod
class SelectedCuisine extends _$SelectedCuisine {
  @override
  String build() => 'Any';

  void set(String value) => state = value;
}

@riverpod
class SelectedCalories extends _$SelectedCalories {
  @override
  int? build() => null; // null means "No Limit"

  void set(int? value) => state = value;
}

@riverpod
class LastIngredients extends _$LastIngredients {
  @override
  String build() => '';

  void set(String value) => state = value;
}

@Riverpod(keepAlive: true)
class SuggestedRecipes extends _$SuggestedRecipes {
  @override
  FutureOr<List<RecipeModel>> build() {
    return [];
  }

  Future<void> generateSuggestions(
      String ingredients, String cuisine, int? calories) async {
    state = const AsyncValue.loading();
    try {
      // We can use the same use case but maybe with a slightly different prompt nuance
      // For now, reusing the standard generation is the most robust way to get "AI" results.
      // Ideally, the repository would support a "suggestion" flag, but standard generation works.
      final recipes = await ref
          .read(getRecipesUseCaseProvider)
          .call(ingredients, cuisine, calories);
      state = AsyncValue.data(recipes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
class GeneratedRecipes extends _$GeneratedRecipes {
  @override
  FutureOr<List<RecipeModel>> build() {
    return [];
  }

  Future<void> generate(
      String ingredients, String cuisine, int? calories) async {
    state = const AsyncValue.loading();
    try {
      final recipes = await ref
          .read(getRecipesUseCaseProvider)
          .call(ingredients, cuisine, calories);
      state = AsyncValue.data(recipes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  @override
  FutureOr<List<RecipeModel>> build() async {
    return await ref.read(getFavoritesUseCaseProvider).call();
  }

  Future<void> toggleFavorite(RecipeModel recipe) async {
    await ref.read(toggleFavoriteUseCaseProvider).call(recipe);
    // Refresh the list
    state = AsyncValue.data(await ref.read(getFavoritesUseCaseProvider).call());
  }

  bool isFavorite(RecipeModel recipe) {
    return ref.read(toggleFavoriteUseCaseProvider).isFavorite(recipe);
  }

  Future<void> clearAll() async {
    await ref.read(clearFavoritesUseCaseProvider).call();
    state = const AsyncValue.data([]);
  }
}

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
