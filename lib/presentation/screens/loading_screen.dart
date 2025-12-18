import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> _loadingTexts = [
    "We're looking for the best recipes for you...",
    "Heating up the pans...",
    "Chopping fresh ingredients...",
    "Seasoning with love...",
    "Almost ready to serve!",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTextRotation();
  }

  void _startTextRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _loadingTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              // Using a high-quality food loading animation from LottieFiles (network)
              SizedBox(
                height: 250,
                width: 250,
                child: Lottie.network(
                  'https://lottie.host/5a0c0e86-8809-4184-9080-692582046467/Zp8K6v3qD2.json', // A nice cooking animation
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.soup_kitchen,
                            size: 100, color: Theme.of(context).primaryColor)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2.seconds);
                  },
                ),
              ),
              const SizedBox(height: 48),

              // Animated Text Switcher
              SizedBox(
                height: 60, // Fixed height to prevent layout jumps
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _loadingTexts[_currentIndex],
                    key: ValueKey<String>(_loadingTexts[_currentIndex]),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Subtle loader at bottom
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
