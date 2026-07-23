import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _formController;
  late final AnimationController _floatingController;
  late final AnimationController _glitchController;

  // Entrance animations
  late final Animation<double> _logoSlide;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;

  // Form staggered animations
  late final List<Animation<Offset>> _fieldSlides;
  late final List<Animation<double>> _fieldFades;

  // Floating idle
  late final Animation<double> _floatingOffset;

  // Glitch tick
  late final Animation<double> _glitchOffset;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalRed = Color(0xFFFF3B30);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _brutalPink = Color(0xFFFF6EC7);
  static const _gridGray = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();

    // Logo / top entrance
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoSlide = Tween<double>(begin: -80, end: 0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );
    _logoRotation = Tween<double>(begin: -0.2, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Form fields staggered
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    const fieldCount = 5; // email, password, remember, login btn, signup
    _fieldSlides = List.generate(fieldCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.35).clamp(0.0, 1.0);
      final direction =
          i.isEven ? const Offset(-1.2, 0) : const Offset(1.2, 0);
      return Tween<Offset>(begin: direction, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _formController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    _fieldFades = List.generate(fieldCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _formController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Floating idle
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatingOffset = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Glitch tick for decorative elements
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _glitchOffset = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );

    // Kick off
    _entranceController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _formController.dispose();
    _floatingController.dispose();
    _glitchController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _entranceController,
          _formController,
          _floatingController,
          _glitchController,
        ]),
        builder: (context, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  // ── Decorative grid lines ──
                  _buildGridOverlay(),

                  const SizedBox(height: 20),

                  // ── Logo Block ──
                  _buildLogoBlock(),

                  const SizedBox(height: 32),

                  // ── Login Form ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildLoginForm(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  GRID OVERLAY (decorative brutalist element)
  // ═══════════════════════════════════════════════════════════
  Widget _buildGridOverlay() {
    return Transform.translate(
      offset: Offset(0, _logoSlide.value),
      child: Opacity(
        opacity: _logoFade.value,
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
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  LOGO BLOCK
  // ═══════════════════════════════════════════════════════════
  Widget _buildLogoBlock() {
    return Transform.translate(
      offset: Offset(0, _logoSlide.value),
      child: Opacity(
        opacity: _logoFade.value,
        child: AnimatedBuilder(
          animation: _floatingOffset,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingOffset.value),
              child: child,
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo with brutalist frame
              Transform.scale(
                scale: _logoScale.value,
                child: Transform.rotate(
                  angle: _logoRotation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _brutalYellow,
                      border: Border.all(color: _rawWhite, width: 4),
                      boxShadow: const [
                        BoxShadow(color: _brutalRed, offset: Offset(6, 6)),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.bolt,
                      size: 48,
                      color: _bgBlack,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title with glitch
              Stack(
                children: [
                  Transform.translate(
                    offset: Offset(_glitchOffset.value, 2),
                    child: Text(
                      'SIGN IN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: _brutalRed.withValues(alpha: 0.4),
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  Text(
                    'SIGN IN',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: _rawWhite,
                      letterSpacing: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _brutalYellow.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  'ACCESS YOUR ACCOUNT',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    color: _brutalYellow,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  LOGIN FORM
  // ═══════════════════════════════════════════════════════════
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email field
        _buildAnimatedField(
          index: 0,
          child: _buildBrutalTextField(
            controller: _emailController,
            label: 'EMAIL',
            icon: Icons.email_outlined,
            accentColor: _brutalBlue,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 16),

        // Password field
        _buildAnimatedField(
          index: 1,
          child: _buildBrutalTextField(
            controller: _passwordController,
            label: 'PASSWORD',
            icon: Icons.lock_outline,
            accentColor: _brutalRed,
            obscure: _obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: _brutalRed,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Remember me + forgot password
        _buildAnimatedField(
          index: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember me
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _rememberMe ? _brutalYellow : _bgBlack,
                        border: Border.all(
                          color: _rememberMe
                              ? _brutalYellow
                              : _rawWhite.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: _rememberMe
                            ? const [
                                BoxShadow(
                                  color: _brutalYellow,
                                  offset: Offset(2, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: _rememberMe
                          ? const Icon(Icons.check, size: 14, color: _bgBlack)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'REMEMBER ME',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _rawWhite.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Forgot password
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _brutalPink.withValues(alpha: 0.6),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'FORGOT?',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _brutalPink,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Login button
        _buildAnimatedField(
          index: 3,
          child: _BrutalLoginButton(
            label: 'LOG IN',
            color: _brutalYellow,
            onTap: _handleLogin,
          ),
        ),
        const SizedBox(height: 16),

        // Divider
        _buildAnimatedField(
          index: 3,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  color: _rawWhite.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _rawWhite.withValues(alpha: 0.3),
                    letterSpacing: 3,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: _rawWhite.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Social login buttons
        _buildAnimatedField(
          index: 4,
          child: Row(
            children: [
              Expanded(
                child: _BrutalSocialButton(
                  label: 'GOOGLE',
                  icon: Icons.g_mobiledata,
                  color: _brutalRed,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BrutalSocialButton(
                  label: 'GITHUB',
                  icon: Icons.code,
                  color: _rawWhite,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Sign up link
        _buildAnimatedField(
          index: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NO ACCOUNT? ',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _rawWhite.withValues(alpha: 0.4),
                  letterSpacing: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: _brutalGreen, width: 2),
                    ),
                  ),
                  child: Text(
                    'SIGN UP',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _brutalGreen,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ANIMATED FIELD WRAPPER
  // ═══════════════════════════════════════════════════════════
  Widget _buildAnimatedField({required int index, required Widget child}) {
    final safeIndex = index.clamp(0, _fieldSlides.length - 1);
    return SlideTransition(
      position: _fieldSlides[safeIndex],
      child: FadeTransition(
        opacity: _fieldFades[safeIndex],
        child: child,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  BRUTAL TEXT FIELD
  // ═══════════════════════════════════════════════════════════
  Widget _buildBrutalTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _gridGray,
        border: Border.all(color: _rawWhite.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.4),
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon block
          Container(
            width: 52,
            height: 56,
            decoration: BoxDecoration(
              color: _bgBlack,
              border: Border(
                right: BorderSide(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          // Input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscure,
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                color: _rawWhite,
                letterSpacing: 0.5,
              ),
              cursorColor: accentColor,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _rawWhite.withValues(alpha: 0.25),
                  letterSpacing: 3,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BRUTAL LOGIN BUTTON
// ═══════════════════════════════════════════════════════════════
class _BrutalLoginButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BrutalLoginButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_BrutalLoginButton> createState() => _BrutalLoginButtonState();
}

class _BrutalLoginButtonState extends State<_BrutalLoginButton> {
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
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 4 : 0,
          _pressed ? 4 : 0,
          0,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: _rawWhite, width: 3),
          boxShadow: [
            BoxShadow(
              color: _rawWhite,
              offset: Offset(_pressed ? 1 : 5, _pressed ? 1 : 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _bgBlack,
              letterSpacing: 6,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BRUTAL SOCIAL BUTTON
// ═══════════════════════════════════════════════════════════════
class _BrutalSocialButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BrutalSocialButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_BrutalSocialButton> createState() => _BrutalSocialButtonState();
}

class _BrutalSocialButtonState extends State<_BrutalSocialButton> {
  bool _pressed = false;

  static const _bgBlack = Color(0xFF0A0A0A);
  static const _gridGray = Color(0xFF1A1A1A);

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
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 3 : 0,
          _pressed ? 3 : 0,
          0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _gridGray,
          border: Border.all(
            color: widget.color.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              offset: Offset(_pressed ? 1 : 4, _pressed ? 1 : 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.color, size: 22),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: widget.color,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
