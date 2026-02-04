import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class RecipeModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(1)
  @JsonKey(name: 'cuisine')
  final String cuisine;

  @HiveField(2)
  @JsonKey(name: 'ingredients')
  final List<String> ingredients;

  @HiveField(3)
  @JsonKey(name: 'instructions')
  final List<String> instructions;

  @HiveField(4)
  @JsonKey(name: 'prepTime')
  final int prepTime; // in minutes

  @HiveField(5)
  @JsonKey(name: 'calories')
  final int calories;

  @HiveField(6)
  @JsonKey(name: 'difficulty')
  final String difficulty;

  // Constructor
  RecipeModel({
    required this.name,
    required this.cuisine,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.calories,
    this.difficulty = 'Medium', // Default for migration/fallback
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}
