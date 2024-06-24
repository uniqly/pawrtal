import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final String title;
  final String details;
  final String imagePath;

  const EventDetailsScreen({
    super.key,
    required this.title,
    required this.details,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loadEventImage(imagePath),
            const SizedBox(height: 16.0),
            Text(
              details,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadEventImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      );
    }
  }
}