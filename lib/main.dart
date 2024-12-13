import 'package:flutter/material.dart';
import 'conversion_logic.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конвертер',
      home: ConversionSelectionScreen(),
    );
  }
}

class ConversionSelectionScreen extends StatelessWidget {
  final List<String> conversionTypes = [
    'Масса',
    'Валюта',
    'Температура',
    'Длина',
    'Площадь',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Конвертер')),
      body: ListView.builder(
        itemCount: conversionTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(conversionTypes[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConversionScreen(conversionType: conversionTypes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversionScreen extends StatefulWidget {
  final String conversionType;

  ConversionScreen({required this.conversionType});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedFromUnit = '';
  String _selectedToUnit = '';
  double? _result;

  final Map<String, List<String>> unitsMap = {
    'Масса': ['Граммы', 'Килограммы', 'Фунты', 'Тонны'],
    'Валюта': ['USD', 'EUR', 'RUB'],
    'Температура': ['Цельсий', 'Фаренгейт', 'Кельвин'],
    'Длина': ['Сантиметр', 'Метр', 'Километр'],
    'Площадь': ['Кв. метр', 'Кв. километр', 'Гектар'],
  };

  ConversionType getConversionType() {
    switch (widget.conversionType) {
      case 'Масса':
        return ConversionType.weight;
      case 'Валюта':
        return ConversionType.currency;
      case 'Температура':
        return ConversionType.temperature;
      case 'Длина':
        return ConversionType.length;
      case 'Площадь':
        return ConversionType.area;
      default:
        throw Exception('invalid type');
    }
  }

  void _swapUnits() {
    setState(() {
      final temp = _selectedFromUnit;
      _selectedFromUnit = _selectedToUnit;
      _selectedToUnit = temp;
    });
  }

  void _convert() {
    final double? input = double.tryParse(_inputController.text);
    if (input == null) {
      setState(() {
        _result = null;
      });
      return;
    }

    _result = ConversionLogic.convert(
        getConversionType(), _selectedFromUnit, _selectedToUnit, input);
    setState(() {});
  }

  void _updateInput(String value) {
    setState(() {
      _inputController.text += value;
    });
  }

  void _clearInput() {
    setState(() {
      _inputController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedFromUnit = unitsMap[widget.conversionType]!.first;
    _selectedToUnit = unitsMap[widget.conversionType]!.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Конвертация ${widget.conversionType}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedToUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedToUnit = newValue!;
                    });
                  },
                  items: unitsMap[widget.conversionType]!
                      .map<DropdownMenuItem<String>>((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _swapUnits,
                ),
                DropdownButton<String>(
                  value: _selectedFromUnit,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFromUnit = newValue!;
                    });
                  },
                  items: unitsMap[widget.conversionType]!
                      .map<DropdownMenuItem<String>>((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                ),
              ],
            ),
            if (_result != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Результат: $_result',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            TextField(
              controller: _inputController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Введите значение'),
            ),
            SizedBox(height: 20),
            _buildNumberPad(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Конвертировать'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('.'),
            _buildNumberButton('0'),
            _buildClearButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String value) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () => _updateInput(value),
        child: Text(value, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildClearButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: _clearInput,
        child: Icon(Icons.backspace, size: 24),
      ),
    );
  }
}
