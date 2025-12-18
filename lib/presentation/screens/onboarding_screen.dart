import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';
import '../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  late AnimationController _timerController;
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': AppConstants.onboardingTitle1,
      'desc': AppConstants.onboardingDesc1,
      'icon': 'inventory_2',
    },
    {
      'title': AppConstants.onboardingTitle2,
      'desc': AppConstants.onboardingDesc2,
      'icon': 'public',
    },
    {
      'title': AppConstants.onboardingTitle3,
      'desc': AppConstants.onboardingDesc3,
      'icon': 'soup_kitchen',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onTimerComplete();
      }
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.reset();
    _timerController.forward();
  }

  void _onTimerComplete() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    _timerController.stop();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  void _onPageChanged(int idx) {
    setState(() => _currentPage = idx);
    if (_currentPage < _pages.length) {
      _startTimer();
    } else {
      _timerController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Timer and Skip Button
            AnimatedBuilder(
              animation: _timerController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _timerController.value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconData(_pages[index]['icon']!),
                          size: 150,
                          color: Theme.of(context).primaryColor,
                        ).animate().scale(duration: 600.ms),
                        const SizedBox(height: 40),
                        Text(
                          _pages[index]['title']!,
                          style: GoogleFonts.cairo(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .moveY(begin: 20, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]['desc']!,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: _currentPage == index ? 30 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  // Standard Next/Start Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                      style: const TextStyle(fontSize: 16),
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

  IconData _getIconData(String name) {
    // Simple mapper
    switch (name) {
      case 'inventory_2':
        return Icons.inventory_2;
      case 'public':
        return Icons.public;
      case 'soup_kitchen':
        return Icons.soup_kitchen;
      default:
        return Icons.star;
    }
  }
}
