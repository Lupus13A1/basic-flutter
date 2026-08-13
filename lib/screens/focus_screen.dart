import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> with TickerProviderStateMixin {
  late final AnimationController _glitchController;
  late final Animation<double> _glitchOffset;
  
  bool _isRunning = false;

  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalPink = Color(0xFFFF6EC7);
  static const _gridGray = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _glitchOffset = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _glitchController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isRunning)
                        Transform.translate(
                          offset: Offset(_glitchOffset.value * 2, _glitchOffset.value * 2),
                          child: Text(
                            '25:00',
                            style: GoogleFonts.spaceMono(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: _brutalPink.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      Text(
                        '25:00',
                        style: GoogleFonts.spaceMono(
                          fontSize: 80,
                          fontWeight: FontWeight.w900,
                          color: _isRunning ? _brutalPink : _rawWhite,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: _brutalYellow, width: 2),
                ),
                child: Text(
                  'DEEP WORK',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: _brutalYellow,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isRunning = !_isRunning;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: _isRunning ? _gridGray : _brutalYellow,
                    border: Border.all(color: _rawWhite, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _isRunning ? _brutalPink : _rawWhite,
                        offset: const Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isRunning ? 'ABORT' : 'INITIATE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: _isRunning ? _rawWhite : _bgBlack,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
