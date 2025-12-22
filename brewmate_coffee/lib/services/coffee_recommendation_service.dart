// lib/services/coffee_recommendation_service.dart (FIXED)

import 'weather_service.dart';
import 'coffee_calculator.dart';

class CoffeeRecommendationService {
  static final Map<WeatherCategory, List<RecommendedCoffee>> _recommendations =
      {
    WeatherCategory.cold: [
      RecommendedCoffee(
        name: 'Cappuccino',
        description: 'Hangat, creamy, dan mengenyangkan',
        coffeeType: 'cappuccino',
        baseRecipe: 'Klasik dengan foam susu tebal',
      ),
      RecommendedCoffee(
        name: 'Latte',
        description: 'Lembut dengan susu hangat',
        coffeeType: 'latte',
        baseRecipe: 'Espresso dengan susu lebih banyak',
      ),
      RecommendedCoffee(
        name: 'Kopi Tubruk',
        description: 'Tradisional Indonesia yang kuat',
        coffeeType: 'espresso',
        baseRecipe: 'Kopi bubuk dengan air panas',
      ),
      RecommendedCoffee(
        name: 'Mocha Panas',
        description: 'Perpaduan kopi dan cokelat',
        coffeeType: 'mocha',
        baseRecipe: 'Espresso dengan susu dan cokelat',
      ),
    ],
    WeatherCategory.hot: [
      RecommendedCoffee(
        name: 'Es Kopi Susu',
        description: 'Segar dengan susu dingin',
        coffeeType: 'latte',
        baseRecipe: 'Espresso dengan susu dan es',
      ),
      RecommendedCoffee(
        name: 'Cold Brew',
        description: 'Kopi yang direndam lama',
        coffeeType: 'americano',
        baseRecipe: 'Kopi kasar dengan air dingin',
      ),
      RecommendedCoffee(
        name: 'Affogato',
        description: 'Espresso dengan es krim',
        coffeeType: 'espresso',
        baseRecipe: 'Espresso panas di atas es krim',
      ),
      RecommendedCoffee(
        name: 'Es Americano',
        description: 'Kopi hitam dengan es',
        coffeeType: 'americano',
        baseRecipe: 'Espresso dengan air dingin',
      ),
    ],
    WeatherCategory.rainy: [
      RecommendedCoffee(
        name: 'Kopi Jahe',
        description: 'Hangat dengan jahe segar',
        coffeeType: 'americano',
        baseRecipe: 'Kopi hitam dengan jahe',
      ),
      RecommendedCoffee(
        name: 'Spiced Coffee',
        description: 'Dengan rempah-rempah',
        coffeeType: 'espresso',
        baseRecipe: 'Kopi dengan kayu manis',
      ),
    ],
    WeatherCategory.cloudy: [
      RecommendedCoffee(
        name: 'Americano Hangat',
        description: 'Seimbang dan ringan',
        coffeeType: 'americano',
        baseRecipe: 'Espresso dengan air panas',
      ),
      RecommendedCoffee(
        name: 'Flat White',
        description: 'Kuat dengan susu halus',
        coffeeType: 'latte',
        baseRecipe: 'Espresso dengan susu microfoam',
      ),
      RecommendedCoffee(
        name: 'Kopi Susu Gula Aren',
        description: 'Manis alami gula aren',
        coffeeType: 'latte',
        baseRecipe: 'Kopi dengan susu dan gula aren',
      ),
    ],
    WeatherCategory.windy: [
      RecommendedCoffee(
        name: 'Vietnamese Coffee',
        description: 'Kuat dengan susu kental manis',
        coffeeType: 'espresso',
        baseRecipe: 'Kopi robusta dengan susu kental',
      ),
      RecommendedCoffee(
        name: 'Kopi Tubruk Jahe',
        description: 'Hangat dengan jahe',
        coffeeType: 'espresso',
        baseRecipe: 'Kopi bubuk dengan jahe geprek',
      ),
    ],
    WeatherCategory.pleasant: [
      RecommendedCoffee(
        name: 'Espresso',
        description: 'Klasik dan kuat',
        coffeeType: 'espresso',
        baseRecipe: 'Single shot espresso',
      ),
      RecommendedCoffee(
        name: 'Macchiato',
        description: 'Espresso dengan sedikit susu',
        coffeeType: 'macchiato',
        baseRecipe: 'Espresso dengan foam susu',
      ),
      RecommendedCoffee(
        name: 'Cortado',
        description: 'Seimbang antara kopi dan susu',
        coffeeType: 'latte',
        baseRecipe: 'Espresso dengan susu panas',
      ),
    ],
  };

  // Get recommendations based on weather
  static List<RecommendedCoffee> getRecommendations(WeatherCategory category) {
    return _recommendations[category] ??
        _recommendations[WeatherCategory.pleasant]!;
  }

  // Generate detailed recipe for recommended coffee
  static Map<String, dynamic> generateRecipe(
    String coffeeType,
    String cupSize,
    String strength,
    String? customName,
    String? customDescription,
  ) {
    // Calculate ingredients based on type
    Map<String, double> ingredients = {};
    List<String> instructions = [];
    String displayName = customName ?? coffeeType.toUpperCase();
    String description = customDescription ?? '';

    // Base recipes for different coffee types
    switch (coffeeType) {
      case 'cappuccino':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      case 'latte':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      case 'americano':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      case 'espresso':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      case 'mocha':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      case 'macchiato':
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: coffeeType,
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
        break;

      default:
        ingredients = CoffeeCalculator.calculateIngredients(
          coffeeType: 'espresso',
          cupSize: cupSize,
          strength: strength,
        );
        instructions = CoffeeCalculator.generateInstructions(
          coffeeType,
          cupSize,
        );
    }

    // Special modifications based on description
    if (description.contains('Jahe')) {
      instructions.add('Tambahkan jahe geprek ke dalam kopi');
      if (!ingredients.containsKey('jahe')) {
        ingredients['jahe'] = 5.0; // 5g jahe
      }
    }

    if (description.contains('Gula Aren')) {
      instructions.add('Tambahkan gula aren cair sesuai selera');
      if (!ingredients.containsKey('gula_aren')) {
        ingredients['gula_aren'] = 10.0; // 10ml gula aren
      }
    }

    if (description.contains('Cold') || coffeeType.contains('cold')) {
      instructions = [
        'Giling kopi kasar untuk cold brew',
        'Tambahkan kopi ke dalam wadah',
        'Tuang air dingin dengan perbandingan 1:8',
        'Aduk rata',
        'Tutup dan simpan di kulkas 12-24 jam',
        'Saring kopi menggunakan filter',
        'Sajikan dengan es batu',
      ];
    }

    return {
      'ingredients': ingredients,
      'instructions': instructions,
      'displayName': displayName,
      'description': description,
    };
  }
}

class RecommendedCoffee {
  final String name;
  final String description;
  final String coffeeType;
  final String baseRecipe;

  RecommendedCoffee({
    required this.name,
    required this.description,
    required this.coffeeType,
    required this.baseRecipe,
  });
}
