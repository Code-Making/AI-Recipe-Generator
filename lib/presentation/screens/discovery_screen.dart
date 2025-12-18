import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Discovery
    final trending = [
      {'title': 'Spicy Hummus', 'image': '🥣', 'cuisine': 'Arabic'},
      {'title': 'Sushi Roll', 'image': '🍣', 'cuisine': 'Japanese'},
      {'title': 'Pasta Carbonara', 'image': '🍝', 'cuisine': 'Italian'},
      {'title': 'Tacos', 'image': '🌮', 'cuisine': 'Mexican'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Trending Now",
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().moveX(),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final item = trending[index];
              return Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['image']!,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      item['cuisine']!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ).animate().scale(delay: 100.ms * index);
            },
          ),
        ],
      ),
    );
  }
}
