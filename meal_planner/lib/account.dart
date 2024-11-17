import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountPage extends StatefulWidget {
  final String objectId;
  final String name;

  const AccountPage({Key? key, required this.objectId, required this.name})
      : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _calorieController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();

  bool _isUserHealthInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkUserHealth();
  }

  @override
  void dispose() {
    _calorieController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _checkUserHealth() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://cop4331-t23.xyz:5079/api/getuserhealth/${widget.objectId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isUserHealthInitialized = true;
        });
      }
    } catch (error) {
      // Log error or handle it
      print("Error checking user health: $error");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final calorieIntake = int.tryParse(_calorieController.text) ?? 0;
      final carbs = int.tryParse(_carbsController.text) ?? 0;
      final protein = int.tryParse(_proteinController.text) ?? 0;
      final fat = int.tryParse(_fatController.text) ?? 0;

      final url = _isUserHealthInitialized
          ? 'http://cop4331-t23.xyz:5079/api/updateuserhealth'
          : 'http://cop4331-t23.xyz:5079/api/createuserhealth';

      final body = jsonEncode({
        'userId': widget.objectId,
        'cal': calorieIntake,
        'carb': carbs,
        'prot': protein,
        'fat': fat,
      });

      try {
        final response = _isUserHealthInitialized
            ? await http.put(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: body,
              )
            : await http.post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: body,
              );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_isUserHealthInitialized
                    ? 'Details updated successfully!'
                    : 'Details saved successfully!')),
          );

          if (!_isUserHealthInitialized) {
            setState(() {
              _isUserHealthInitialized = true;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${widget.name}, update your daily intake below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _calorieController,
                    decoration:
                        InputDecoration(labelText: 'Calories (kcal/day)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your daily calorie intake';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _carbsController,
                    decoration:
                        InputDecoration(labelText: 'Carbohydrates (g/day)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your daily carbohydrate intake';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _proteinController,
                    decoration: InputDecoration(labelText: 'Protein (g/day)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your daily protein intake';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fatController,
                    decoration: InputDecoration(labelText: 'Fat (g/day)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your daily fat intake';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isUserHealthInitialized
                        ? 'Update Details'
                        : 'Save Details'),
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
