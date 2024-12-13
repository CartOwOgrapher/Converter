enum ConversionType { weight, currency, temperature, length, area }

class ConversionLogic {
  static double? convert(
      ConversionType type, String from, String to, double value) {
    switch (type) {
      case ConversionType.weight:
        return _convertWeight(from, to, value);
      case ConversionType.currency:
        return _convertCurrency(from, to, value);
      case ConversionType.temperature:
        return _convertTemperature(from, to, value);
      case ConversionType.length:
        return _convertLength(from, to, value);
      case ConversionType.area:
        return _convertArea(from, to, value);
      default:
        return null;
    }
  }

  static double? _convertWeight(String from, String to, double value) {
    const Map<String, double> weightUnits = {
      'Граммы': 1.0,
      'Килограммы': 1000.0,
      'Фунты': 453.59237,
      'Тонны': 1000000,
    };

    if (weightUnits.containsKey(from) && weightUnits.containsKey(to)) {
      return value * (weightUnits[to]! / weightUnits[from]!);
    }
    return null;
  }

  static double? _convertCurrency(String from, String to, double value) {
    const Map<String, double> currencyRates = {
      'USD': 1.0,
      'EUR': 0.95,
      'RUB': 103.50,
    };

    if (currencyRates.containsKey(from) && currencyRates.containsKey(to)) {
      return value * (currencyRates[to]! / currencyRates[from]!);
    }
    return null;
  }

  static double? _convertTemperature(String from, String to, double value) {
    if (from == to) return value;

    if (from == 'Цельсий') {
      if (to == 'Фаренгейт') return (value * 9 / 5) + 32;
      if (to == 'Кельвин') return value + 273.15;
    } else if (from == 'Фаренгейт') {
      if (to == 'Цельсий') return (value - 32) * 5 / 9;
      if (to == 'Кельвин') return (value - 32) * 5 / 9 + 273.15;
    } else if (from == 'Кельвин') {
      if (to == 'Цельсий') return value - 273.15;
      if (to == 'Фаренгейт') return (value - 273.15) * 9 / 5 + 32;
    }
    return null;
  }

  static double? _convertLength(String from, String to, double value) {
    const Map<String, double> lengthUnits = {
      'Сантиметр': 1.0,
      'Метр': 100.0,
      'Километр': 100000.0,
    };

    if (lengthUnits.containsKey(from) && lengthUnits.containsKey(to)) {
      return value * (lengthUnits[to]! / lengthUnits[from]!);
    }
    return null;
  }

  static double? _convertArea(String from, String to, double value) {
    const Map<String, double> areaUnits = {
      'Кв. метр': 1.0,
      'Кв. километр': 1e6,
      'Гектар': 1e4,
    };

    if (areaUnits.containsKey(from) && areaUnits.containsKey(to)) {
      return value * (areaUnits[to]! / areaUnits[from]!);
    }
    return null;
  }
}
