import 'package:flutter/material.dart';

class EventDetailsView extends StatelessWidget {
  final String title;
  final String dateRange;
  final String location;
  final String description;
  final String imagePath;
  final String creatorId;
  final String eventId;

  const EventDetailsView({
    super.key,
    required this.title,
    required this.dateRange,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.creatorId,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loadEventImage(imagePath),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Date: $dateRange\nLocation: $location',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle "Interested" button press
                      },
                      icon: const Icon(Icons.star),
                      label: const Text('Interested'),
                    ),
                  ),
                  const SizedBox(width: 10), // Add some spacing between the buttons
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle "Share" button press
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
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
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    }
  }
}