import 'dart:async';

import 'models/models.dart';
import 'repository.dart';

class MemoryRepository extends Repository {
  final _currentRecipes = <Recipe>[];
  final _currentIngredients = <Ingredient>[];
  Stream<List<Recipe>>? _recipeStream;
  Stream<List<Ingredient>>? _ingredientStream;
  final _recipeStreamController = StreamController<List<Recipe>>();
  final _ingredientStreamController = StreamController<List<Ingredient>>();

  @override
  Future init() {
    return Future.value();
  }

  @override
  Future<List<Recipe>> findAllRecipes() {
    return Future.value(_currentRecipes);
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    if (_recipeStream == null) {
      _recipeStream = _recipeStreamController.stream;
    }
    return _recipeStream!;
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    if (_ingredientStream == null) {
      _ingredientStream = _ingredientStreamController.stream;
    }
    return _ingredientStream!;
  }

  @override
  Future<Recipe> findRecipeById(int id) async {
    return _currentRecipes.firstWhere((recipe) => recipe.id == id);
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return Future.value(_currentIngredients);
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    final recipe =
        _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();
    return Future.value(recipeIngredients);
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    _currentRecipes.add(recipe);
    _recipeStreamController.sink.add(_currentRecipes);
    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }
    return Future.value(0);
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    if (ingredients.length != 0) {
      _currentIngredients.addAll(ingredients);
      _ingredientStreamController.sink.add(_currentIngredients);
    }
    return Future.value(<int>[]);
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    _currentRecipes.remove(recipe);
    _recipeStreamController.sink.add(_currentRecipes);
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) async {
    _currentIngredients.remove(ingredient);
    _ingredientStreamController.sink.add(_currentIngredients);
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) async {
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));
    _ingredientStreamController.sink.add(_currentIngredients);
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) async {
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);
    _ingredientStreamController.sink.add(_currentIngredients);
  }

  @override
  void close() {
    _recipeStreamController.close();
    _ingredientStreamController.close();
  }
}
