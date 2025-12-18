import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<List<RecipeModel>> getFavorites();
  Future<void> addFavorite(RecipeModel recipe);
  Future<void> removeFavorite(RecipeModel recipe);
  Future<void> clearFavorites();
  bool isFavorite(RecipeModel recipe);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final Box<RecipeModel> box;

  RecipeLocalDataSourceImpl(this.box);

  @override
  Future<List<RecipeModel>> getFavorites() async {
    return box.values.toList();
  }

  @override
  Future<void> addFavorite(RecipeModel recipe) async {
    await box.add(recipe);
  }

  @override
  Future<void> removeFavorite(RecipeModel recipe) async {
    // Hive implementation details:
    // Ideally we'd use keys, but for simplicity we find by object equality if HiveObject is used correctly or by unique name.
    // Since RecipeModel extends HiveObject, we can allow recipe.delete().
    if (recipe.isInBox) {
      await recipe.delete();
    } else {
      // Fallback: find key by equality (requires == override or unique ID)
      // For now, let's assume UI passes the object from the box or we handle it by key.
      // A better way is to store IDs. Let's iterate.
      final keyToDelete = box.keys.firstWhere((k) {
        final item = box.get(k);
        return item?.name == recipe.name; // Simple matching by name
      }, orElse: () => null);
      if (keyToDelete != null) {
        await box.delete(keyToDelete);
      }
    }
  }

  @override
  bool isFavorite(RecipeModel recipe) {
    if (recipe.isInBox) return true;
    return box.values.any((item) => item.name == recipe.name);
  }

  @override
  Future<void> clearFavorites() async {
    await box.clear();
  }
}
