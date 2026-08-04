import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool wideLayout;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.wideLayout,
  });

  @override
  Widget build(BuildContext context) {
    Widget inputField = TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Enter Target City Name',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search),
      ),
    );

    Widget searchButton = ElevatedButton(
      onPressed: onSearch,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      child: const Text('Check Weather'),
    );

    return wideLayout
        ? Row(children: [Expanded(child: inputField), const SizedBox(width: 16), searchButton])
        : Column(children: [inputField, const SizedBox(height: 12), SizedBox(width: double.infinity, child: searchButton)]);
  }
}
