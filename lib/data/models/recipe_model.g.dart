// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 0;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      name: fields[0] as String,
      cuisine: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      instructions: (fields[3] as List).cast<String>(),
      prepTime: fields[4] as int,
      calories: fields[5] as int,
      difficulty: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.cuisine)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.instructions)
      ..writeByte(4)
      ..write(obj.prepTime)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      prepTime: (json['prepTime'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      difficulty: json['difficulty'] as String? ?? 'Medium',
    );

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cuisine': instance.cuisine,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'prepTime': instance.prepTime,
      'calories': instance.calories,
      'difficulty': instance.difficulty,
    };
