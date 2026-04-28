import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<_WelcomeSlide> _slides = [
    _WelcomeSlide(
      icon: Icons.favorite_rounded,
      quote: '"I liked you then,\nI like you now"',
      subtitle: 'Some feelings never change.\nNeither does good music.',
      gradientColors: [Color(0xFF561C24), Color(0xFF3A1219), Color(0xFF1A0E11)],
    ),
    _WelcomeSlide(
      icon: Icons.auto_awesome_rounded,
      quote: '"Every song\nreminds me of you"',
      subtitle: 'Every melody holds a memory.\nLet yours play on repeat.',
      gradientColors: [Color(0xFF6D2932), Color(0xFF4A1A22), Color(0xFF1A0E11)],
    ),
    _WelcomeSlide(
      icon: Icons.music_note_rounded,
      quote: '"Our melody\nnever fades"',
      subtitle: 'The music that brought us together\nwill keep us forever.',
      gradientColors: [Color(0xFF7A3040), Color(0xFF561C24), Color(0xFF1A0E11)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/home');
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _fadeController.reset();
              _scaleController.reset();
              _fadeController.forward();
              _scaleController.forward();
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return _buildSlide(slide, index);
            },
          ),
          // Skip button
          if (_currentPage < 2)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Skip',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.warmBeige.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          // Bottom section
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: _currentPage == index ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.lightCream
                            : AppColors.warmBeige.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                // Next / Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBurgundy,
                        foregroundColor: AppColors.lightCream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.deepBurgundy.withValues(alpha: 0.5),
                      ),
                      child: Text(
                        _currentPage == 2 ? 'Get Started' : 'Next',
                        style: AppTextStyles.button.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(_WelcomeSlide slide, int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Icon
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.warmBeige.withValues(alpha: 0.15),
                          AppColors.deepBurgundy.withValues(alpha: 0.3),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.warmBeige.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      slide.icon,
                      size: 52,
                      color: AppColors.lightCream,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Quote
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  slide.quote,
                  style: AppTextStyles.welcomeQuote,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  slide.subtitle,
                  style: AppTextStyles.welcomeSubtext,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeSlide {
  final IconData icon;
  final String quote;
  final String subtitle;
  final List<Color> gradientColors;

  const _WelcomeSlide({
    required this.icon,
    required this.quote,
    required this.subtitle,
    required this.gradientColors,
  });
}
