import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brewmate_coffee/models/coffee_recipe.dart';
import 'package:brewmate_coffee/models/brewing_history.dart';
import 'package:brewmate_coffee/models/user_preferences.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get recipesCollection => _firestore.collection('recipes');
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get brewingHistoryCollection =>
      _firestore.collection('brewing_history');

  // ========== RECIPE METHODS ==========

  // Save recipe with better error handling
  Future<void> saveRecipe(CoffeeRecipe recipe) async {
    try {
      print('💾 Saving recipe: ${recipe.id}');
      print('   User: ${recipe.userId}');
      print('   Favorite: ${recipe.isFavorite}');
      print('   Type: ${recipe.coffeeType}');

      // Pastikan data sesuai format Firestore
      final recipeData = recipe.toMap();

      // Konversi ingredients ke Map<String, dynamic>
      final ingredientsMap = <String, dynamic>{};
      recipe.ingredients.forEach((key, value) {
        ingredientsMap[key] = value;
      });
      recipeData['ingredients'] = ingredientsMap;

      // Tambah timestamp untuk updatedAt
      recipeData['updatedAt'] = FieldValue.serverTimestamp();

      await recipesCollection
          .doc(recipe.id)
          .set(recipeData, SetOptions(merge: true));

      print('✅ Recipe saved successfully!');
    } catch (e) {
      print('❌ Failed to save recipe: $e');
      throw Exception('Failed to save recipe: $e');
    }
  }

  // Get user's recipes
  Stream<List<CoffeeRecipe>> getUserRecipes(String userId) {
    print('📋 Getting recipes for user: $userId');

    return recipesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
      print('❌ Error in getUserRecipes stream: $error');
      return Stream.value([]);
    }).map((snapshot) {
      print('📊 Retrieved ${snapshot.docs.length} recipes');

      final recipes = snapshot.docs
          .map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              return CoffeeRecipe.fromMap(doc.id, data);
            } catch (e) {
              print('❌ Error parsing recipe ${doc.id}: $e');
              return null;
            }
          })
          .where((recipe) => recipe != null)
          .cast<CoffeeRecipe>()
          .toList();

      return recipes;
    });
  }

  // Get favorite recipes
  Stream<List<CoffeeRecipe>> getFavoriteRecipes(String userId) {
    print('❤️ Getting favorite recipes for user: $userId');

    return recipesCollection
        .where('userId', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .handleError((error) {
      print('❌ Error in getFavoriteRecipes stream: $error');
      // If there's an index error, try without ordering
      return recipesCollection
          .where('userId', isEqualTo: userId)
          .where('isFavorite', isEqualTo: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return CoffeeRecipe.fromMap(
                      doc.id, doc.data() as Map<String, dynamic>);
                } catch (e) {
                  print('❌ Error parsing favorite recipe ${doc.id}: $e');
                  return null;
                }
              })
              .where((recipe) => recipe != null)
              .cast<CoffeeRecipe>()
              .toList()
            ..sort((a, b) =>
                b.createdAt.compareTo(a.createdAt))); // Sort in memory
    }).map((snapshot) {
      final favorites = snapshot.docs
          .map((doc) {
            try {
              return CoffeeRecipe.fromMap(
                  doc.id, doc.data() as Map<String, dynamic>);
            } catch (e) {
              print('❌ Error parsing favorite recipe ${doc.id}: $e');
              return null;
            }
          })
          .where((recipe) => recipe != null)
          .cast<CoffeeRecipe>()
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort in memory

      print('📊 Found ${favorites.length} favorite recipes');
      return favorites;
    });
  }

  // Update recipe favorite status
  Future<void> toggleFavorite(String recipeId, bool isFavorite) async {
    try {
      print('🔄 Toggling favorite for $recipeId to: $isFavorite');

      await recipesCollection.doc(recipeId).update({
        'isFavorite': isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Favorite status updated!');
    } catch (e) {
      print('❌ Failed to update favorite: $e');
      // Jika update gagal, coba set dengan create if not exists
      try {
        await recipesCollection.doc(recipeId).set({
          'isFavorite': isFavorite,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('✅ Recipe created with favorite status!');
      } catch (e2) {
        print('❌ Completely failed to update favorite: $e2');
        throw Exception('Failed to update favorite: $e2');
      }
    }
  }

  // Get single recipe by ID
  Future<CoffeeRecipe?> getRecipeById(String recipeId) async {
    try {
      final doc = await recipesCollection.doc(recipeId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return CoffeeRecipe.fromMap(doc.id, data);
      }
      return null;
    } catch (e) {
      print('❌ Failed to get recipe: $e');
      return null;
    }
  }

  // Delete recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      print('🗑️ Deleting recipe: $recipeId');

      // Cek dulu apakah recipe ada
      final doc = await recipesCollection.doc(recipeId).get();
      if (!doc.exists) {
        throw Exception('Recipe not found');
      }

      await recipesCollection.doc(recipeId).delete();
      print('✅ Recipe deleted!');
    } catch (e) {
      print('❌ Failed to delete recipe: $e');
      throw Exception('Failed to delete recipe: $e');
    }
  }

  // Update recipe (full update)
  Future<void> updateRecipe(CoffeeRecipe recipe) async {
    try {
      print('✏️ Updating recipe: ${recipe.id}');

      final updateData = {
        'coffeeType': recipe.coffeeType,
        'cupSize': recipe.cupSize,
        'strength': recipe.strength,
        'coffeeAmount': recipe.coffeeAmount,
        'waterAmount': recipe.waterAmount,
        'milkAmount': recipe.milkAmount,
        'chocolateAmount': recipe.chocolateAmount,
        'instructions': recipe.instructions,
        'isFavorite': recipe.isFavorite,
        'ingredients': recipe.ingredients,
        'customName': recipe.customName,
        'customDescription': recipe.customDescription,
        'weatherContext': recipe.weatherContext,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      updateData.removeWhere((key, value) => value == null);

      await recipesCollection.doc(recipe.id).update(updateData);

      print('✅ Recipe updated!');
    } catch (e) {
      print('❌ Failed to update recipe: $e');
      throw Exception('Failed to update recipe: $e');
    }
  }

  // Get recipe count for user (simplified version)
  Future<int> getRecipeCount(String userId) async {
    try {
      final querySnapshot =
          await recipesCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('❌ Failed to get recipe count: $e');
      return 0;
    }
  }

  // Get favorite count for user (simplified version)
  Future<int> getFavoriteCount(String userId) async {
    try {
      final querySnapshot = await recipesCollection
          .where('userId', isEqualTo: userId)
          .where('isFavorite', isEqualTo: true)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('❌ Failed to get favorite count: $e');
      return 0;
    }
  }

  // Search recipes
  Stream<List<CoffeeRecipe>> searchRecipes(String userId, String query) {
    final lowercaseQuery = query.toLowerCase();

    return recipesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .handleError((error) {
      print('❌ Error in searchRecipes stream: $error');
      return Stream.value([]);
    }).map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CoffeeRecipe.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .where((recipe) =>
              recipe.coffeeType.toLowerCase().contains(lowercaseQuery) ||
              (recipe.customName?.toLowerCase().contains(lowercaseQuery) ??
                  false) ||
              (recipe.customDescription
                      ?.toLowerCase()
                      .contains(lowercaseQuery) ??
                  false))
          .toList();
    });
  }

  // ========== BREWING HISTORY METHODS ==========

  // Save brewing history
  Future<void> saveBrewingHistory(BrewingHistory history) async {
    try {
      print('📝 Saving brewing history: ${history.id}');

      final historyData = history.toMap();
      historyData['brewedAt'] = FieldValue.serverTimestamp();

      await brewingHistoryCollection
          .doc(history.id)
          .set(historyData, SetOptions(merge: true));

      print('✅ Brewing history saved!');
    } catch (e) {
      print('❌ Failed to save brewing history: $e');
      throw Exception('Failed to save brewing history: $e');
    }
  }

  // Get user's brewing history
  Stream<List<BrewingHistory>> getUserBrewingHistory(String userId) {
    return brewingHistoryCollection
        .where('userId', isEqualTo: userId)
        .orderBy('brewedAt', descending: true)
        .snapshots()
        .handleError((error) {
      print('❌ Error in getUserBrewingHistory stream: $error');
      return Stream.value([]);
    }).map((snapshot) {
      return snapshot.docs
          .map((doc) => BrewingHistory.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get recent brewing history (last 10)
  Stream<List<BrewingHistory>> getRecentBrewingHistory(String userId,
      {int limit = 10}) {
    return brewingHistoryCollection
        .where('userId', isEqualTo: userId)
        .orderBy('brewedAt', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((error) {
      print('❌ Error in getRecentBrewingHistory stream: $error');
      return Stream.value([]);
    }).map((snapshot) {
      return snapshot.docs
          .map((doc) => BrewingHistory.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Delete brewing history
  Future<void> deleteBrewingHistory(String historyId) async {
    try {
      await brewingHistoryCollection.doc(historyId).delete();
      print('✅ Brewing history deleted!');
    } catch (e) {
      print('❌ Failed to delete brewing history: $e');
      throw Exception('Failed to delete brewing history: $e');
    }
  }

  // ========== USER METHODS ==========

  // Save user preferences
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      final preferencesData = preferences.toMap();
      preferencesData['updatedAt'] = FieldValue.serverTimestamp();

      await usersCollection
          .doc(preferences.userId)
          .collection('preferences')
          .doc('user_preferences')
          .set(preferencesData, SetOptions(merge: true));

      print('✅ User preferences saved!');
    } catch (e) {
      print('❌ Failed to save user preferences: $e');
      throw Exception('Failed to save user preferences: $e');
    }
  }

  // Get user preferences
  Future<UserPreferences?> getUserPreferences(String userId) async {
    try {
      final doc = await usersCollection
          .doc(userId)
          .collection('preferences')
          .doc('user_preferences')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserPreferences.fromMap(data);
      }
      return null;
    } catch (e) {
      print('❌ Failed to get user preferences: $e');
      return null;
    }
  }

  // Stream user preferences
  Stream<UserPreferences?> streamUserPreferences(String userId) {
    return usersCollection
        .doc(userId)
        .collection('preferences')
        .doc('user_preferences')
        .snapshots()
        .handleError((error) {
      print('❌ Error in streamUserPreferences: $error');
      return Stream.value(null);
    }).map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return UserPreferences.fromMap(data);
      }
      return null;
    });
  }

  // ========== STATISTICS METHODS ==========

  // Get user statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final recipes = await getRecipeCount(userId);
      final favorites = await getFavoriteCount(userId);

      // Get brewing history count
      final brewingHistorySnapshot = await brewingHistoryCollection
          .where('userId', isEqualTo: userId)
          .get();
      final brewingCount = brewingHistorySnapshot.docs.length;

      // Get most brewed coffee type
      final coffeeTypeCount = <String, int>{};
      for (final doc in brewingHistorySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final coffeeType = data['coffeeType'] as String? ?? 'unknown';
        coffeeTypeCount[coffeeType] = (coffeeTypeCount[coffeeType] ?? 0) + 1;
      }

      final mostBrewed = coffeeTypeCount.isNotEmpty
          ? coffeeTypeCount.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key
          : 'none';

      return {
        'totalRecipes': recipes,
        'favoriteRecipes': favorites,
        'totalBrews': brewingCount,
        'mostBrewedCoffee': mostBrewed,
        'coffeeTypes': coffeeTypeCount,
      };
    } catch (e) {
      print('❌ Failed to get user statistics: $e');
      return {
        'totalRecipes': 0,
        'favoriteRecipes': 0,
        'totalBrews': 0,
        'mostBrewedCoffee': 'none',
        'coffeeTypes': {},
      };
    }
  }

  // ========== UTILITY METHODS ==========

  // Check if recipe exists
  Future<bool> recipeExists(String recipeId) async {
    try {
      final doc = await recipesCollection.doc(recipeId).get();
      return doc.exists;
    } catch (e) {
      print('❌ Failed to check if recipe exists: $e');
      return false;
    }
  }

  // Batch operations example
  Future<void> batchSaveRecipes(List<CoffeeRecipe> recipes) async {
    try {
      final batch = _firestore.batch();

      for (final recipe in recipes) {
        final recipeData = recipe.toMap();
        recipeData['updatedAt'] = FieldValue.serverTimestamp();

        final docRef = recipesCollection.doc(recipe.id);
        batch.set(docRef, recipeData, SetOptions(merge: true));
      }

      await batch.commit();
      print('✅ ${recipes.length} recipes saved in batch!');
    } catch (e) {
      print('❌ Failed to batch save recipes: $e');
      throw Exception('Failed to batch save recipes: $e');
    }
  }

  // Clear all user data (for testing/cleanup)
  Future<void> clearUserData(String userId) async {
    try {
      // Delete recipes
      final recipesSnapshot =
          await recipesCollection.where('userId', isEqualTo: userId).get();

      final batch = _firestore.batch();
      for (final doc in recipesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete brewing history
      final historySnapshot = await brewingHistoryCollection
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in historySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('✅ User data cleared for $userId');
    } catch (e) {
      print('❌ Failed to clear user data: $e');
      throw Exception('Failed to clear user data: $e');
    }
  }
}
