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

  Future<void> _submitData() async {
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
      'userId': widget.objectId,
      'calories': double.tryParse(_caloriesController.text) ?? 0.0,
      'protein': double.tryParse(_proteinController.text) ?? 0.0,
      'carbs': double.tryParse(_carbsController.text) ?? 0.0,
      'fat': double.tryParse(_fatController.text) ?? 0.0,
    };

    try {
      final response = await http.post(
        Uri.parse('http://cop4331-t23.xyz:5079/api/createmacro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Macro details saved successfully!')),
        );
        _clearFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _clearFields() {
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrient Intake'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _caloriesController,
              decoration:
                  const InputDecoration(labelText: 'Calories Consumed Today'),
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
              decoration:
                  const InputDecoration(labelText: 'Carbs (g) Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fatController,
              decoration:
                  const InputDecoration(labelText: 'Fat (g) Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
