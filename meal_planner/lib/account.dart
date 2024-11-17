import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final String objectId;

  const AccountPage({Key? key, required this.objectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: Center(
        child: Text(
          'Your ObjectId: $objectId',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
