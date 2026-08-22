import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
//  ONBOARDING PAGE DATA MODEL
// ═══════════════════════════════════════════════════════════════

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final Color shadowColor;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.shadowColor,
  });
}

// ═══════════════════════════════════════════════════════════════
//  ONBOARDING SCREEN
// ═══════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalRed = Color(0xFFFF3B30);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _brutalPink = Color(0xFFFF6EC7);

  late final PageController _pageController;
  late final AnimationController _entranceController;
  late final AnimationController _floatingController;
  late final AnimationController _pulseController;

  late final Animation<double> _headerSlide;
  late final Animation<double> _headerFade;
  late final Animation<double> _floatingOffset;

  int _currentPage = 0;
  double _scrollPosition = 0.0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'PLAYER 1\nREADY',
      subtitle: 'SYSTEM INITIALIZED',
      description:
          'Welcome to DEV:GRID. Your ultimate developer sandbox. '
          'Equip your tools, set your loadout, and prepare to execute code with brutal efficiency.',
      accentColor: _brutalBlue,
      shadowColor: _brutalRed,
    ),
    _OnboardingPageData(
      title: 'SELECT\nQUESTS',
      subtitle: 'WORKSPACE & INVENTORY',
      description:
          'Manage your repositories, track active sprints, '
          'and deploy features. Treat every task like a mission. Farm XP and clear the backlog.',
      accentColor: _brutalYellow,
      shadowColor: _brutalPink,
    ),
    _OnboardingPageData(
      title: 'DOMINATE\nLADDER',
      subtitle: 'LEVEL UP YOUR STATS',
      description:
          'Track commit streaks, crush deadlines, and secure '
          'high scores. Join the elite ranks of top performers. Are you ready to press start?',
      accentColor: _brutalGreen,
      shadowColor: _brutalBlue,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _scrollPosition = _pageController.page ?? 0.0;
        });
      }
    });

    // Entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _headerSlide = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Floating animation (smooth bobbing)
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatingOffset = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOutSine),
    );

    // Pulse animation (for glowing game UI elements)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _onNext() {
    if (_currentPage == _pages.length - 1) {
      _onIntroEnd();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutExpo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _entranceController,
          _floatingController,
          _pulseController,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              // ── Retro Scanline / Particle overlay (Game aesthetic) ──
              _buildRetroBackground(),

              SafeArea(
                child: Column(
                  children: [
                    // ── Top gradient bar ──
                    Transform.translate(
                      offset: Offset(0, _headerSlide.value),
                      child: Opacity(
                        opacity: _headerFade.value,
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
                    ),

                    // ── Header (Logo + Skip) ──
                    Transform.translate(
                      offset: Offset(0, _headerSlide.value),
                      child: Opacity(
                        opacity: _headerFade.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Arcade style logo
                              Container(
                                decoration: BoxDecoration(
                                  color: _bgBlack,
                                  border: Border.all(
                                    color: _brutalYellow,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _brutalYellow.withValues(alpha: 0.4 * _pulseController.value),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.videogame_asset,
                                      size: 16,
                                      color: _brutalYellow,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'DEV:GRID',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: _brutalYellow,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Skip button
                              if (_currentPage < _pages.length - 1)
                                GestureDetector(
                                  onTap: _onIntroEnd,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _rawWhite.withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      'SKIP',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 12,
                                        color: _rawWhite.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(width: 60),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Page Content ──
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final page = _pages[index];
                          // Calculate parallax offset for this specific page
                          final pageOffset = _scrollPosition - index;

                          return _OnboardingPage(
                            page: page,
                            pageIndex: index,
                            floatingOffset: _floatingOffset.value,
                            parallaxOffset: pageOffset,
                            pulseValue: _pulseController.value,
                            time: _floatingController.value * pi * 2,
                          );
                        },
                      ),
                    ),

                    // ── Bottom Controls ──
                    _buildBottomControls(),

                    SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Subtle animated background pattern (retro grid / scanlines)
  Widget _buildRetroBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _RetroBackgroundPainter(
          time: _floatingController.value,
          pulse: _pulseController.value,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    final page = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // HP Bar style indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final isActive = index == _currentPage;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  decoration: BoxDecoration(
                    color: isActive ? _pages[index].accentColor : _bgBlack,
                    border: Border.all(
                      color: isActive
                          ? _pages[index].accentColor
                          : _rawWhite.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _pages[index].accentColor.withValues(
                                  alpha: 0.4 + 0.3 * _pulseController.value),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),

          // Action button (PRESS START style on last page)
          _GameActionButton(
            label: isLast ? 'PRESS START' : 'NEXT STAGE',
            color: page.accentColor,
            isPulsing: isLast,
            pulseValue: _pulseController.value,
            onTap: _onNext,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  RETRO BACKGROUND PAINTER
// ═══════════════════════════════════════════════════════════════
class _RetroBackgroundPainter extends CustomPainter {
  final double time;
  final double pulse;

  _RetroBackgroundPainter({required this.time, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F0E8).withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Moving horizontal scanlines
    final step = 40.0;
    final offset = (time * step) % step;
    
    for (double y = offset; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RetroBackgroundPainter oldDelegate) => true;
}

// ═══════════════════════════════════════════════════════════════
//  GAME ACTION BUTTON
// ═══════════════════════════════════════════════════════════════
class _GameActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final bool isPulsing;
  final double pulseValue;
  final VoidCallback onTap;

  const _GameActionButton({
    required this.label,
    required this.color,
    required this.isPulsing,
    required this.pulseValue,
    required this.onTap,
  });

  @override
  State<_GameActionButton> createState() => _GameActionButtonState();
}

class _GameActionButtonState extends State<_GameActionButton> {
  bool _pressed = false;

  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          _pressed ? 4 : 0,
          _pressed ? 4 : 0,
          0,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: widget.isPulsing
              ? Color.lerp(widget.color, _rawWhite, widget.pulseValue * 0.2)
              : widget.color,
          border: Border.all(color: _rawWhite, width: 3),
          boxShadow: [
            BoxShadow(
              color: widget.isPulsing
                  ? widget.color.withValues(alpha: 0.5 + widget.pulseValue * 0.5)
                  : _rawWhite,
              offset: Offset(_pressed ? 0 : 6, _pressed ? 0 : 6),
              blurRadius: widget.isPulsing && !_pressed ? 8 : 0,
            ),
            if (!widget.isPulsing)
               BoxShadow(
                color: _rawWhite,
                offset: Offset(_pressed ? 0 : 6, _pressed ? 0 : 6),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isPulsing)
              Icon(Icons.play_arrow, color: _bgBlack, size: 24),
            if (widget.isPulsing) const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: _bgBlack,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ONBOARDING PAGE (Single Page Content)
// ═══════════════════════════════════════════════════════════════

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData page;
  final int pageIndex;
  final double floatingOffset;
  final double parallaxOffset;
  final double pulseValue;
  final double time;

  static const _rawWhite = Color(0xFFF5F0E8);

  const _OnboardingPage({
    required this.page,
    required this.pageIndex,
    required this.floatingOffset,
    required this.parallaxOffset,
    required this.pulseValue,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Parallax values for text
    final titleOffset = parallaxOffset * 100;
    final subtitleOffset = parallaxOffset * 150;
    final descOffset = parallaxOffset * 200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // ── Large Game-Style Illustration Area ──
          Expanded(
            flex: 5,
            child: _buildIllustration(context),
          ),

          // ── Text Content Area (with Parallax) ──
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Subtitle / "Zone" badge
                Transform.translate(
                  offset: Offset(subtitleOffset, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: page.accentColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: page.accentColor,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '// ${page.subtitle}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: page.accentColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Giant Title
                Transform.translate(
                  offset: Offset(titleOffset, 0),
                  child: Stack(
                    children: [
                      // Glitch shadow 1
                      Transform.translate(
                        offset: Offset(
                            4 + pulseValue * 2, 4 + pulseValue * 2),
                        child: Text(
                          page.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: page.shadowColor.withValues(alpha: 0.8),
                            letterSpacing: 2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      // Glitch shadow 2
                      Transform.translate(
                        offset: Offset(-2 * pulseValue, -2 * pulseValue),
                        child: Text(
                          page.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: page.accentColor.withValues(alpha: 0.8),
                            letterSpacing: 2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      // Main text
                      Text(
                        page.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: _rawWhite,
                          letterSpacing: 2,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              color: page.accentColor.withValues(alpha: 0.5 * pulseValue),
                              blurRadius: 12,
                            )
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Description body
                Transform.translate(
                  offset: Offset(descOffset, 0),
                  child: Text(
                    page.description,
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      color: _rawWhite.withValues(alpha: 0.7),
                      height: 1.5,
                      letterSpacing: 0.5,
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

  Widget _buildIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // The illustration gets a slight scaling/bobbing effect and intense parallax
    final illusParallax = parallaxOffset * 50;

    return Center(
      child: Transform.translate(
        offset: Offset(illusParallax, floatingOffset),
        child: SizedBox(
          width: size.width * 0.9,
          height: size.width * 0.9,
          child: CustomPaint(
            painter: _GameIllustrationPainter(
              pageIndex: pageIndex,
              accentColor: page.accentColor,
              shadowColor: page.shadowColor,
              time: time,
              pulse: pulseValue,
              parallax: parallaxOffset,
            ),
            size: Size(size.width * 0.9, size.width * 0.9),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CUSTOM PAINTER - GAME UI ILLUSTRATIONS
//  Expressive characters, glowing HUDs, playful energy
// ═══════════════════════════════════════════════════════════════

class _GameIllustrationPainter extends CustomPainter {
  final int pageIndex;
  final Color accentColor;
  final Color shadowColor;
  final double time; // 0 to 2PI continuous
  final double pulse; // 0 to 1 pulsing
  final double parallax; 

  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalRed = Color(0xFFFF3B30);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _brutalPink = Color(0xFFFF6EC7);
  static const _gridGray = Color(0xFF1A1A1A);

  _GameIllustrationPainter({
    required this.pageIndex,
    required this.accentColor,
    required this.shadowColor,
    required this.time,
    required this.pulse,
    required this.parallax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    // Background glow
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.4,
      Paint()
        ..color = accentColor.withValues(alpha: 0.1 + 0.05 * pulse)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    // Draw dynamic particles (stars/squares) matching parallax
    _paintParticles(canvas, size, time, parallax);

    switch (pageIndex) {
      case 0:
        _paintPlayerSpawn(canvas, size, cx, cy);
        break;
      case 1:
        _paintQuestBoard(canvas, size, cx, cy);
        break;
      case 2:
        _paintLevelUp(canvas, size, cx, cy);
        break;
    }
  }

  // ═════════════════════════════════════════════════════
  //  PAGE 1: Player Spawn / Loadout (Dynamic Character)
  // ═════════════════════════════════════════════════════
  void _paintPlayerSpawn(Canvas canvas, Size size, double cx, double cy) {
    final breathingScale = 1.0 + sin(time) * 0.02;
    
    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(1.0, breathingScale); // Breathing animation
    canvas.translate(-cx, -cy);

    // HUD Circle in background
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.35,
      Paint()
        ..color = shadowColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    // Rotating dashed HUD
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(time * 0.5);
    final hudPath = Path();
    for (int i = 0; i < 12; i++) {
      hudPath.addArc(
        Rect.fromCircle(center: Offset.zero, radius: size.width * 0.38),
        i * (pi / 6),
        pi / 12,
      );
    }
    canvas.drawPath(
      hudPath, 
      Paint()
        ..color = accentColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
    );
    canvas.restore();

    // ── expressive Player Character (Cyber-Ninja/Hacker style) ──
    final charHeight = size.height * 0.45;
    
    // Hover boots / glow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + charHeight * 0.6), width: 60, height: 16),
      Paint()..color = accentColor.withValues(alpha: 0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Body
    final bodyRect = Rect.fromCenter(center: Offset(cx, cy + charHeight * 0.1), width: 70, height: 90);
    _drawBrutalRect(canvas, bodyRect, _rawWhite, shadowColor: shadowColor);
    
    // Tech jacket details
    canvas.drawLine(Offset(bodyRect.left + 20, bodyRect.top), Offset(bodyRect.left + 20, bodyRect.bottom), Paint()..color = _gridGray..strokeWidth = 4);
    canvas.drawRect(Rect.fromLTWH(bodyRect.right - 25, bodyRect.top + 20, 15, 30), Paint()..color = accentColor);

    // Head / Helmet (Expressive)
    final headRect = Rect.fromCenter(center: Offset(cx, cy - charHeight * 0.35), width: 80, height: 75);
    _drawBrutalRect(canvas, headRect, _gridGray, shadowColor: _bgBlack);
    
    // Glowing Visor (Eyes)
    final visorRect = Rect.fromCenter(center: Offset(cx, cy - charHeight * 0.35), width: 60, height: 25);
    canvas.drawRect(visorRect, Paint()..color = _bgBlack);
    
    // Blink animation
    final blink = sin(time * 3) > 0.9 ? 2.0 : 10.0;
    canvas.drawRect(Rect.fromCenter(center: Offset(cx - 15, cy - charHeight * 0.35), width: 15, height: blink), Paint()..color = accentColor);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx + 15, cy - charHeight * 0.35), width: 15, height: blink), Paint()..color = accentColor);

    // Headset antenna
    canvas.drawLine(Offset(headRect.right, headRect.top + 20), Offset(headRect.right + 20, headRect.top - 10), Paint()..color = _rawWhite..strokeWidth = 4);
    canvas.drawCircle(Offset(headRect.right + 20, headRect.top - 10), 6, Paint()..color = _brutalRed);

    // Dynamic floating arms typing on holo-keyboard
    final leftArm = Path()..moveTo(bodyRect.left, bodyRect.top + 20)..quadraticBezierTo(cx - 80, cy + 20, cx - 40, cy + 60);
    final rightArm = Path()..moveTo(bodyRect.right, bodyRect.top + 20)..quadraticBezierTo(cx + 80, cy + 20, cx + 40, cy + 60);
    canvas.drawPath(leftArm, Paint()..color = _rawWhite..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.square);
    canvas.drawPath(rightArm, Paint()..color = _rawWhite..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.square);

    // Holo Keyboard
    final kbRect = Rect.fromCenter(center: Offset(cx, cy + 70), width: 120, height: 30);
    canvas.drawRect(kbRect, Paint()..color = accentColor.withValues(alpha: 0.2));
    canvas.drawRect(kbRect, Paint()..color = accentColor..style = PaintingStyle.stroke..strokeWidth = 2);
    // Keys typing effect
    for (int i = 0; i < 5; i++) {
      final keyY = kbRect.top + 5 + (sin(time * 5 + i) > 0 ? 5 : 0);
      canvas.drawRect(Rect.fromLTWH(kbRect.left + 10 + i * 20, keyY, 15, 10), Paint()..color = accentColor.withValues(alpha: 0.8));
    }

    // Floating UI Panels (Stats)
    final floatY = sin(time * 2) * 10;
    _drawHUDPanel(canvas, Offset(cx - 130, cy - 80 + floatY), "HP: 100%", _brutalGreen);
    _drawHUDPanel(canvas, Offset(cx + 120, cy - 20 - floatY), "SYS: OK", _brutalBlue);

    canvas.restore();
  }

  // ═════════════════════════════════════════════════════
  //  PAGE 2: Quest Board / Inventory (Dynamic Interaction)
  // ═════════════════════════════════════════════════════
  void _paintQuestBoard(Canvas canvas, Size size, double cx, double cy) {
    // Holographic massive quest board
    final boardRect = Rect.fromCenter(center: Offset(cx, cy - 20), width: size.width * 0.7, height: size.height * 0.5);
    
    canvas.drawRect(boardRect.shift(const Offset(8, 8)), Paint()..color = shadowColor.withValues(alpha: 0.3));
    canvas.drawRect(boardRect, Paint()..color = _gridGray);
    canvas.drawRect(boardRect, Paint()..color = _rawWhite..style = PaintingStyle.stroke..strokeWidth = 4);
    
    // Header
    canvas.drawRect(Rect.fromLTWH(boardRect.left, boardRect.top, boardRect.width, 30), Paint()..color = accentColor);
    canvas.drawRect(Rect.fromLTWH(boardRect.left + 10, boardRect.top + 10, 60, 10), Paint()..color = _bgBlack);

    // Quest Cards floating out of board
    final cardFloat = sin(time) * 15;
    
    // Card 1 (Back)
    _drawHUDCard(canvas, Offset(boardRect.left + 40, boardRect.top + 60), _brutalRed);
    // Card 2 (Middle)
    _drawHUDCard(canvas, Offset(boardRect.left + 120, boardRect.top + 80), _brutalPink);
    
    // Card 3 (Pop out / interacting)
    canvas.save();
    canvas.translate(cx + 20, cy + cardFloat);
    canvas.rotate(0.1);
    final popCard = Rect.fromCenter(center: Offset.zero, width: 90, height: 110);
    _drawBrutalRect(canvas, popCard, _brutalYellow, shadowColor: _rawWhite);
    canvas.drawRect(Rect.fromLTWH(-35, -40, 70, 10), Paint()..color = _bgBlack);
    canvas.drawRect(Rect.fromLTWH(-35, -20, 50, 6), Paint()..color = _bgBlack.withValues(alpha: 0.5));
    // XP Star on card
    _drawStar(canvas, Offset(0, 15), 15, _brutalBlue);
    canvas.restore();

    // Character (Profile view, grabbing card)
    final charX = cx - 90;
    final charY = cy + 50;
    
    // Body
    _drawBrutalRect(canvas, Rect.fromCenter(center: Offset(charX, charY), width: 50, height: 80), _brutalGreen, shadowColor: _gridGray);
    // Head looking up
    _drawBrutalRect(canvas, Rect.fromCenter(center: Offset(charX + 10, charY - 60), width: 60, height: 50), _rawWhite, shadowColor: _bgBlack);
    // Eye visor
    canvas.drawRect(Rect.fromLTWH(charX + 15, charY - 70, 25, 15), Paint()..color = _brutalBlue);
    canvas.drawCircle(Offset(charX + 30, charY - 62), 3, Paint()..color = _rawWhite);

    // Arm reaching for card
    final armReach = Path()..moveTo(charX, charY - 20)..quadraticBezierTo(charX + 50, charY - 40, cx - 10, cy + cardFloat);
    canvas.drawPath(armReach, Paint()..color = _brutalGreen..style = PaintingStyle.stroke..strokeWidth = 14..strokeCap = StrokeCap.square);
    // Hand grasping
    canvas.drawRect(Rect.fromCenter(center: Offset(cx - 15, cy + cardFloat), width: 20, height: 25), Paint()..color = _rawWhite);
  }

  // ═════════════════════════════════════════════════════
  //  PAGE 3: Level Up / Dominate (Victory State)
  // ═════════════════════════════════════════════════════
  void _paintLevelUp(Canvas canvas, Size size, double cx, double cy) {
    // Dynamic sunburst background
    canvas.save();
    canvas.translate(cx, cy - 20);
    canvas.rotate(time * 0.2);
    final burstPaint = Paint()..color = accentColor.withValues(alpha: 0.15)..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final path = Path()..moveTo(0, 0)..lineTo(-20, -size.height)..lineTo(20, -size.height)..close();
      canvas.drawPath(path, burstPaint);
      canvas.rotate(pi / 4);
    }
    canvas.restore();

    // Giant "LVL UP" Badge behind character
    final badgeScale = 1.0 + pulse * 0.1;
    canvas.save();
    canvas.translate(cx, cy - 50);
    canvas.scale(badgeScale);
    _drawStar(canvas, Offset.zero, 90, shadowColor.withValues(alpha: 0.6));
    _drawStar(canvas, Offset.zero, 80, _rawWhite);
    _drawStar(canvas, Offset.zero, 70, accentColor);
    canvas.restore();

    // Character jumping (Joy/Victory pose)
    final jumpY = cy + 40 - abs(sin(time * 3)) * 30; // Bouncing math
    
    // Legs jumping
    canvas.drawLine(Offset(cx - 20, jumpY + 40), Offset(cx - 40, jumpY + 80), Paint()..color = _gridGray..strokeWidth = 14..strokeCap = StrokeCap.square);
    canvas.drawLine(Offset(cx + 20, jumpY + 40), Offset(cx + 40, jumpY + 70), Paint()..color = _gridGray..strokeWidth = 14..strokeCap = StrokeCap.square);
    
    // Body
    _drawBrutalRect(canvas, Rect.fromCenter(center: Offset(cx, jumpY), width: 60, height: 80), _brutalBlue, shadowColor: _rawWhite);
    
    // Head
    _drawBrutalRect(canvas, Rect.fromCenter(center: Offset(cx, jumpY - 70), width: 70, height: 60), _rawWhite, shadowColor: _bgBlack);
    
    // Happy Eyes ^ ^
    final eyePaint = Paint()..color = _bgBlack..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(cx - 20, jumpY - 70)..quadraticBezierTo(cx - 15, jumpY - 80, cx - 10, jumpY - 70), eyePaint);
    canvas.drawPath(Path()..moveTo(cx + 10, jumpY - 70)..quadraticBezierTo(cx + 15, jumpY - 80, cx + 20, jumpY - 70), eyePaint);

    // Arms cheering up
    canvas.drawLine(Offset(cx - 30, jumpY - 20), Offset(cx - 70, jumpY - 90), Paint()..color = _brutalBlue..strokeWidth = 12..strokeCap = StrokeCap.square);
    canvas.drawLine(Offset(cx + 30, jumpY - 20), Offset(cx + 70, jumpY - 100), Paint()..color = _brutalBlue..strokeWidth = 12..strokeCap = StrokeCap.square);

    // Confetti particles
    for (int i = 0; i < 10; i++) {
      final pX = cx + cos(time * 2 + i * pi / 5) * (80 + i * 10);
      final pY = cy - 20 + sin(time * 2 + i * pi / 5) * (80 + i * 10) - (time * 50 % 100);
      final colors = [_brutalYellow, _brutalRed, _brutalPink, _brutalBlue];
      canvas.drawRect(Rect.fromCenter(center: Offset(pX, pY), width: 10, height: 10), Paint()..color = colors[i % 4]);
    }
  }

  // ═════════════════════════════════════════════════════
  //  UTILITY DRAWING METHODS
  // ═════════════════════════════════════════════════════

  void _paintParticles(Canvas canvas, Size size, double time, double parallax) {
    final rand = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 15; i++) {
      final startX = rand.nextDouble() * size.width;
      final startY = rand.nextDouble() * size.height;
      final speed = 0.5 + rand.nextDouble();
      final pSize = 4.0 + rand.nextDouble() * 6.0;
      final colors = [_brutalYellow, _brutalGreen, _brutalPink, _rawWhite];
      paint.color = colors[i % colors.length].withValues(alpha: 0.3);
      
      // Move up slowly + apply parallax based on depth (speed)
      var x = startX - (parallax * 100 * speed);
      var y = startY - ((time * 20 * speed) % size.height);
      
      // Wrap around
      x = x % size.width;
      if (x < 0) x += size.width;
      y = y % size.height;
      if (y < 0) y += size.height;

      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: pSize, height: pSize), paint);
      } else {
        canvas.drawCircle(Offset(x, y), pSize / 2, paint);
      }
    }
  }

  void _drawBrutalRect(Canvas canvas, Rect rect, Color color, {Color? shadowColor}) {
    if (shadowColor != null) {
      canvas.drawRect(rect.shift(const Offset(4, 4)), Paint()..color = shadowColor);
    }
    canvas.drawRect(rect, Paint()..color = color);
    canvas.drawRect(rect, Paint()..color = _bgBlack..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  void _drawHUDPanel(Canvas canvas, Offset pos, String text, Color color) {
    final rect = Rect.fromCenter(center: pos, width: 80, height: 35);
    _drawBrutalRect(canvas, rect, _bgBlack, shadowColor: color);
    canvas.drawRect(rect, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2);
    
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: GoogleFonts.spaceMono(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(canvas, Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2));
  }

  void _drawHUDCard(Canvas canvas, Offset pos, Color color) {
    final rect = Rect.fromLTWH(pos.dx, pos.dy, 70, 90);
    _drawBrutalRect(canvas, rect, _gridGray, shadowColor: _bgBlack);
    canvas.drawRect(Rect.fromLTWH(pos.dx, pos.dy, 70, 20), Paint()..color = color);
    canvas.drawRect(Rect.fromLTWH(pos.dx + 5, pos.dy + 30, 40, 6), Paint()..color = _rawWhite.withValues(alpha: 0.3));
    canvas.drawRect(Rect.fromLTWH(pos.dx + 5, pos.dy + 45, 60, 6), Paint()..color = _rawWhite.withValues(alpha: 0.3));
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final path = Path();
    final innerRadius = radius * 0.4;
    for (int i = 0; i < 10; i++) {
      final r = i % 2 == 0 ? radius : innerRadius;
      final angle = i * (pi / 5) - pi / 2;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(path, Paint()..color = _bgBlack..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  double abs(double v) => v < 0 ? -v : v;

  @override
  bool shouldRepaint(covariant _GameIllustrationPainter oldDelegate) {
    return oldDelegate.time != time || 
           oldDelegate.pulse != pulse || 
           oldDelegate.parallax != parallax ||
           oldDelegate.pageIndex != pageIndex;
  }
}
