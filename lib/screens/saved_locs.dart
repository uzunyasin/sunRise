import 'package:flutter/material.dart';

class SavedLocationsPage extends StatefulWidget {
  const SavedLocationsPage({Key? key}) : super(key: key);

  @override
  State<SavedLocationsPage> createState() => _SavedLocationsPageState();
}

class _SavedLocationsPageState extends State<SavedLocationsPage> {
  @override
  Widget build(BuildContext context) {
    print("geldi saved");
    return Container(
      color: Colors.blue,
    );
  }
}
