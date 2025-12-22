// lib/services/coffee_calculator.dart (update)
class CoffeeCalculator {
  // Extended cup sizes with more options
  static const Map<String, double> _cupSizes = {
    'extra_small': 120.0, // Demitasse
    'small': 180.0, // Small cup
    'medium': 250.0, // Regular cup
    'large': 350.0, // Large cup
    'extra_large': 450.0, // Extra large
    'mug': 350.0, // Coffee mug
    'travel': 400.0, // Travel mug
  };

  // Detailed coffee ratios
  static const Map<String, Map<String, double>> _coffeeRatios = {
    'espresso': {
      'very_light': 1 / 3,
      'light': 1 / 2.5,
      'regular': 1 / 2,
      'strong': 1 / 1.8,
      'very_strong': 1 / 1.5,
    },
    'latte': {
      'very_light': 1 / 15,
      'light': 1 / 12,
      'regular': 1 / 10,
      'strong': 1 / 8,
      'very_strong': 1 / 6,
    },
    'cappuccino': {
      'very_light': 1 / 10,
      'light': 1 / 8,
      'regular': 1 / 6,
      'strong': 1 / 5,
      'very_strong': 1 / 4,
    },
    'americano': {
      'very_light': 1 / 20,
      'light': 1 / 18,
      'regular': 1 / 15,
      'strong': 1 / 12,
      'very_strong': 1 / 10,
    },
    'mocha': {
      'very_light': 1 / 12,
      'light': 1 / 10,
      'regular': 1 / 8,
      'strong': 1 / 6,
      'very_strong': 1 / 5,
    },
    'macchiato': {
      'very_light': 1 / 4,
      'light': 1 / 3.5,
      'regular': 1 / 3,
      'strong': 1 / 2.5,
      'very_strong': 1 / 2,
    },
  };

  // Milk ratios
  static const Map<String, double> _milkRatios = {
    'latte': 0.7,
    'cappuccino': 0.5,
    'macchiato': 0.1,
    'flat_white': 0.6,
    'cortado': 0.5,
  };

  // Chocolate ratios for mocha
  static const Map<String, double> _chocolateRatios = {
    'light': 0.05,
    'regular': 0.08,
    'strong': 0.12,
  };

  // Calculate ingredients with more detailed options
  static Map<String, double> calculateIngredients({
    required String coffeeType,
    required String cupSize,
    required String strength,
    String? milkStrength = 'regular',
    String? chocolateStrength = 'regular',
  }) {
    final cupVolume = _cupSizes[cupSize] ?? 250.0;
    final ratio = _coffeeRatios[coffeeType]?[strength] ?? 1 / 15;

    double coffeeAmount;
    double waterAmount;
    double? milkAmount;
    double? chocolateAmount;

    // Special handling for espresso
    if (coffeeType == 'espresso') {
      switch (strength) {
        case 'very_light':
          coffeeAmount = 14.0;
          waterAmount = 42.0;
          break;
        case 'light':
          coffeeAmount = 16.0;
          waterAmount = 40.0;
          break;
        case 'regular':
          coffeeAmount = 18.0;
          waterAmount = 36.0;
          break;
        case 'strong':
          coffeeAmount = 20.0;
          waterAmount = 34.0;
          break;
        case 'very_strong':
          coffeeAmount = 22.0;
          waterAmount = 33.0;
          break;
        default:
          coffeeAmount = 18.0;
          waterAmount = 36.0;
      }
    } else {
      coffeeAmount = cupVolume * ratio;

      // Handle milk-based drinks
      final milkRatio = _milkRatios[coffeeType];
      if (milkRatio != null) {
        milkAmount = cupVolume * milkRatio;
        waterAmount = coffeeAmount * 2; // Espresso base
      } else {
        waterAmount = cupVolume - coffeeAmount;
      }

      // Handle chocolate for mocha
      if (coffeeType == 'mocha') {
        chocolateAmount =
            cupVolume * (_chocolateRatios[chocolateStrength] ?? 0.08);
        if (milkAmount != null) {
          milkAmount = milkAmount - chocolateAmount;
        }
      }
    }

    // Round to 1 decimal place
    Map<String, double> result = {
      'coffee': double.parse(coffeeAmount.toStringAsFixed(1)),
      'water': double.parse(waterAmount.toStringAsFixed(1)),
    };

    if (milkAmount != null && milkAmount > 0) {
      result['milk'] = double.parse(milkAmount.toStringAsFixed(1));
    }

    if (chocolateAmount != null && chocolateAmount > 0) {
      result['chocolate'] = double.parse(chocolateAmount.toStringAsFixed(1));
    }

    return result;
  }

  // Get all available cup sizes
  static List<String> getAvailableCupSizes() {
    return _cupSizes.keys.toList();
  }

  // Get all available strengths
  static List<String> getAvailableStrengths() {
    return ['very_light', 'light', 'regular', 'strong', 'very_strong'];
  }

  // Generate detailed instructions based on coffee type and cup size
  static List<String> generateInstructions(String coffeeType, String cupSize) {
    final cupVolume = _cupSizes[cupSize] ?? 250.0;
    List<String> instructions = [];

    switch (coffeeType) {
      case 'espresso':
        instructions = [
          'Giling ${cupVolume < 200 ? '16g' : '18g'} biji kopi',
          'Tamp kopi dengan tekanan merata (30kg)',
          'Pasang portafilter ke mesin espresso',
          'Ekstraksi selama ${cupVolume < 200 ? '22-26' : '25-30'} detik',
          'Target yield: ${cupVolume < 200 ? '32g' : '36g'} espresso',
          'Periksa crema berwarna cokelat kecoklatan',
          'Sajikan dalam cangkir espresso yang telah dipanaskan',
        ];
        break;

      case 'latte':
        instructions = [
          'Siapkan ${cupVolume > 300 ? 'double' : 'single'} shot espresso',
          'Giling kopi untuk espresso',
          'Ekstrak espresso 25-30 detik',
          'Panaskan susu hingga 65°C dengan steam wand',
          'Tekan susu untuk menciptakan microfoam',
          'Tuang susu ke espresso dengan teknik pouring',
          'Buat latte art dasar (heart atau rosetta)',
          'Sajikan segera untuk rasa terbaik',
        ];
        break;

      case 'cappuccino':
        instructions = [
          'Giling kopi untuk single shot espresso',
          'Ekstrak espresso dengan crema tebal',
          'Panaskan susu hingga 60°C',
          'Buat foam yang kental dan padat',
          'Rasio 1:1:1 (espresso:susu:foam)',
          'Tuang susu perlahan dari ketinggian',
          'Tambahkan foam di atasnya',
          'Taburi dengan bubuk cokelat atau kayu manis',
        ];
        break;

      case 'americano':
        instructions = [
          'Siapkan ${cupVolume > 300 ? 'double' : 'single'} shot espresso',
          'Panaskan air hingga 92-96°C',
          'Tuang espresso ke cangkir ${cupVolume}ml',
          'Tambahkan air panas perlahan',
          'Aduk dengan sendok panjang',
          'Biarkan selama 30 detik untuk menetralkan',
          'Cicipi dan sesuaikan kekuatan jika perlu',
          'Sajikan dengan atau tanpa gula',
        ];
        break;

      case 'cold_brew':
        instructions = [
          'Giling 60g kopi kasar (coarse grind)',
          'Tambahkan ke wadah kedap udara',
          'Tuang 500ml air dingin atau suhu ruang',
          'Aduk hingga semua kopi basah',
          'Tutup dan simpan di kulkas 12-24 jam',
          'Saring menggunakan filter kertas atau kain',
          'Simpan concentrate di kulkas hingga 2 minggu',
          'Sajikan dengan rasio 1:1 dengan air/es/susu',
        ];
        break;

      case 'mocha':
        instructions = [
          'Siapkan ${cupVolume > 300 ? 'double' : 'single'} shot espresso',
          'Campur 1-2 sendok cokelat bubuk dengan sedikit susu panas',
          'Panaskan susu hingga 60°C',
          'Tuang campuran cokelat ke cangkir',
          'Tambahkan espresso dan aduk',
          'Tuang susu panas dengan teknik layering',
          'Buat foam susu di atasnya',
          'Taburi dengan bubuk cokelat atau marshmallow',
          'Opsional: tambahkan whipped cream',
        ];
        break;

      default:
        instructions = [
          'Siapkan ${cupVolume > 250 ? 'double' : 'single'} shot espresso sebagai base',
          'Sesuaikan takaran bahan sesuai ukuran cangkir',
          'Ikuti teknik dasar untuk jenis kopi yang dipilih',
          'Gunakan air dengan suhu yang tepat (92-96°C)',
          'Perhatikan waktu ekstraksi',
          'Sajikan dalam cangkir yang sesuai',
          'Nikmati segera untuk pengalaman terbaik',
        ];
    }

    return instructions;
  }
}
