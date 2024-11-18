import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomRecipesPage extends StatefulWidget {
  final String objectId;

  const CustomRecipesPage({Key? key, required this.objectId}) : super(key: key);

  @override
  _CustomRecipesPageState createState() => _CustomRecipesPageState();
}

class _CustomRecipesPageState extends State<CustomRecipesPage> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMacroData();
  }

  Future<void> _fetchMacroData() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
            'http://cop4331-t23.xyz:5079/api/getmacro/${widget.objectId}'),
      );

      if (response.statusCode == 200) {
        final macroData = jsonDecode(response.body)['Macro'];
        setState(() {
          _caloriesController.text = macroData['cal'].toString();
          _proteinController.text = macroData['prot'].toString();
          _carbsController.text = macroData['carb'].toString();
          _fatController.text = macroData['fat'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error fetching macro data: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateMacroData(String search) async {
    if (_caloriesController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    final data = {
      'cal': double.tryParse(_caloriesController.text) ?? 0.0,
      'carb': double.tryParse(_carbsController.text) ?? 0.0,
      'fat': double.tryParse(_fatController.text) ?? 0.0,
      'prot': double.tryParse(_proteinController.text) ?? 0.0,
    };

    setState(() => _isLoading = true);

    try {
      final response = await http.put(
        Uri.parse(
            'http://cop4331-t23.xyz:5079/api/updatemacro/${widget.objectId}/$search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Macros updated successfully!')),
        );
        _fetchMacroData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrient Intake'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(
                        labelText: 'Calories Consumed Today'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _proteinController,
                    decoration: const InputDecoration(
                        labelText: 'Protein (g) Consumed Today'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _carbsController,
                    decoration: const InputDecoration(
                        labelText: 'Carbs (g) Consumed Today'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _fatController,
                    decoration: const InputDecoration(
                        labelText: 'Fat (g) Consumed Today'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _updateMacroData('CU'),
                          child: const Text('Update Macros'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _updateMacroData('R'),
                          child: const Text('Reset Macros'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _updateMacroData('A'),
                          child: const Text('Add Macros'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _updateMacroData('S'),
                          child: const Text('Subtract Macros'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
