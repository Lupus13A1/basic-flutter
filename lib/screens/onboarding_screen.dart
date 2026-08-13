import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalRed = Color(0xFFFF3B30);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _brutalPink = Color(0xFFFF6EC7);
  static const _gridGray = Color(0xFF1A1A1A);

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildImage(IconData icon, Color color) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: _rawWhite, width: 4),
          boxShadow: const [
            BoxShadow(color: _rawWhite, offset: Offset(8, 8)),
          ],
        ),
        padding: const EdgeInsets.all(40),
        child: Icon(
          icon,
          size: 100,
          color: _bgBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: _rawWhite,
        letterSpacing: 4,
      ),
      bodyTextStyle: GoogleFonts.spaceMono(
        fontSize: 16,
        color: _rawWhite.withValues(alpha: 0.8),
        letterSpacing: 1,
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: _bgBlack,
      imagePadding: const EdgeInsets.only(top: 40, bottom: 24),
    );

    return Scaffold(
      backgroundColor: _bgBlack,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background grid lines (optional, matches login)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _brutalRed,
                      _brutalYellow,
                      _brutalBlue,
                      _brutalPink,
                      _brutalGreen,
                    ],
                  ),
                ),
              ),
            ),
            
            // Introduction Screen
            IntroductionScreen(
              globalBackgroundColor: Colors.transparent,
              allowImplicitScrolling: true,
              pages: [
                PageViewModel(
                  title: "INITIALIZE",
                  body: "Welcome to DEV:GRID.\nThe ultimate system to track your tasks and dominate your day.",
                  image: _buildImage(Icons.terminal, _brutalBlue),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "EXECUTE",
                  body: "Complete missions, earn XP, and level up your profile. No excuses.",
                  image: _buildImage(Icons.bolt, _brutalYellow),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "DOMINATE",
                  body: "Join the community of elite performers. Are you ready?",
                  image: _buildImage(Icons.local_fire_department, _brutalRed),
                  decoration: pageDecoration,
                ),
              ],
              onDone: _onIntroEnd,
              onSkip: _onIntroEnd,
              showSkipButton: true,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: false,
              
              // Brutalist Skip Button
              skip: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: _rawWhite.withValues(alpha: 0.5), width: 2),
                ),
                child: Text(
                  'SKIP',
                  style: GoogleFonts.spaceGrotesk(
                    color: _rawWhite,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              // Brutalist Next Button
              next: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _brutalPink,
                  border: Border.all(color: _rawWhite, width: 2),
                  boxShadow: const [BoxShadow(color: _rawWhite, offset: Offset(3, 3))],
                ),
                child: const Icon(Icons.arrow_forward, color: _bgBlack),
              ),
              
              // Brutalist Done Button
              done: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _brutalGreen,
                  border: Border.all(color: _rawWhite, width: 2),
                  boxShadow: const [BoxShadow(color: _rawWhite, offset: Offset(3, 3))],
                ),
                child: Text(
                  'START',
                  style: GoogleFonts.spaceGrotesk(
                    color: _bgBlack,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              curve: Curves.fastOutSlowIn,
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              dotsDecorator: const DotsDecorator(
                size: Size(12.0, 12.0),
                shape: BeveledRectangleBorder(),
                color: _gridGray,
                activeSize: Size(24.0, 12.0),
                activeShape: BeveledRectangleBorder(),
                activeColor: _brutalYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
