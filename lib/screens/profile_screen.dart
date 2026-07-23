import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final AnimationController _sectionsController;
  late final AnimationController _floatingController;

  late final Animation<double> _headerSlide;
  late final Animation<double> _headerFade;
  late final Animation<double> _avatarScale;
  late final Animation<double> _avatarRotation;

  // Staggered section animations
  late final List<Animation<Offset>> _sectionSlides;
  late final List<Animation<double>> _sectionFades;

  // Floating idle animation
  late final Animation<double> _floatingOffset;

  @override
  void initState() {
    super.initState();

    // Header entrance
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerSlide = Tween<double>(begin: -120, end: 0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _avatarScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );
    _avatarRotation = Tween<double>(begin: -0.15, end: 0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Section stagger entrance
    _sectionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    const sectionCount = 8;
    _sectionSlides = List.generate(sectionCount, (i) {
      final start = (i * 0.08).clamp(0.0, 0.7);
      final end = (start + 0.35).clamp(0.0, 1.0);
      // Alternate slide direction for brutalist feel
      final direction = i.isEven ? const Offset(-1.2, 0) : const Offset(1.2, 0);
      return Tween<Offset>(begin: direction, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _sectionsController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    _sectionFades = List.generate(sectionCount, (i) {
      final start = (i * 0.08).clamp(0.0, 0.7);
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _sectionsController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Floating idle animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatingOffset = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Kick off animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _sectionsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _sectionsController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalRed = Color(0xFFFF3B30);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _brutalPink = Color(0xFFFF6EC7);
  static const _gridGray = Color(0xFF1A1A1A);
  static const _borderColor = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _headerController,
          _sectionsController,
          _floatingController,
        ]),
        builder: (context, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Brutalist App Bar ──
              SliverToBoxAdapter(child: _buildBrutalHeader()),

              // ── Profile Card ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _buildProfileCard(),
                ),
              ),

              // ── Settings Sections ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 12),
                    _buildSectionHeader('ACCOUNT SETTINGS', 0, _brutalYellow),
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      label: 'Personal Information',
                      color: _brutalYellow,
                      index: 1,
                    ),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      label: 'Password & Security',
                      color: _brutalRed,
                      index: 2,
                    ),
                    _buildSettingsTile(
                      icon: Icons.notifications_none,
                      label: 'Notifications Preferences',
                      color: _brutalBlue,
                      index: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildSectionHeader('COMMUNITY SETTINGS', 4, _brutalPink),
                    _buildSettingsTile(
                      icon: Icons.people_outline,
                      label: 'Friends & Social',
                      color: _brutalPink,
                      index: 5,
                    ),
                    _buildSettingsTile(
                      icon: Icons.bookmark_border,
                      label: 'Following List',
                      color: _brutalGreen,
                      index: 6,
                    ),
                    const SizedBox(height: 20),
                    _buildSectionHeader('OTHER', 7, _brutalRed),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      label: 'FAQ',
                      color: _brutalYellow,
                      index: 7,
                    ),
                    _buildSettingsTile(
                      icon: Icons.support_agent,
                      label: 'Help Center',
                      color: _brutalBlue,
                      index: 7, // reuse last animation slot
                    ),
                    const SizedBox(height: 32),
                    _buildLogoutButton(),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  BRUTAL HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildBrutalHeader() {
    return Transform.translate(
      offset: Offset(0, _headerSlide.value),
      child: Opacity(
        opacity: _headerFade.value,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: _brutalYellow,
            border: Border(bottom: BorderSide(color: _bgBlack, width: 4)),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            bottom: 16,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: _bgBlack,
                    border: Border.all(color: _rawWhite, width: 2),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back,
                    color: _brutalYellow,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'PROFILE',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _bgBlack,
                    letterSpacing: 4,
                    height: 1,
                  ),
                ),
              ),
              // Decorative brutalist element
              Transform.rotate(
                angle: _avatarRotation.value,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _brutalRed,
                    border: Border.all(color: _bgBlack, width: 3),
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      color: _brutalYellow,
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

  // ═══════════════════════════════════════════════════════════
  //  PROFILE CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildProfileCard() {
    return Transform.translate(
      offset: Offset(0, _headerSlide.value * 0.5),
      child: Opacity(
        opacity: _headerFade.value,
        child: AnimatedBuilder(
          animation: _floatingOffset,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingOffset.value),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _gridGray,
              border: Border.all(color: _borderColor, width: 3),
              boxShadow: const [
                BoxShadow(color: _brutalYellow, offset: Offset(6, 6)),
              ],
            ),
            child: Column(
              children: [
                // Top accent bar
                Container(
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
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Avatar with brutalist frame
                      Transform.scale(
                        scale: _avatarScale.value,
                        child: Transform.rotate(
                          angle: _avatarRotation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _brutalYellow,
                                width: 4,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: _brutalRed,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                'https://play-lh.googleusercontent.com/ozKb0LNI5Rt8Z4wU3iBUg-r8lBvhyRgJL89cahZqvbbxpwyacU7Kw1HjJqVSkHmQ1JWP0qW7Za-Uez85KZbZbBE',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: _bgBlack,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: _brutalYellow,
                                        value:
                                            progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stack) {
                                  return Container(
                                    color: _bgBlack,
                                    child: Icon(
                                      Icons.person,
                                      size: 48,
                                      color: _brutalYellow.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name with glitch-style offset
                            Stack(
                              children: [
                                Transform.translate(
                                  offset: const Offset(2, 2),
                                  child: Text(
                                    'Thanet Chankhua',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: _brutalRed.withValues(alpha: 0.5),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Thanet Chankhua',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: _rawWhite,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Email with monospace
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _brutalYellow.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                's6803052411341@kmutnb.ac.th',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 12,
                                  color: _brutalYellow,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Edit button
                            _BrutalSmallButton(
                              label: 'EDIT PROFILE',
                              color: _brutalBlue,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom stats bar
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: _borderColor, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildStatBlock('POSTS', '142', _brutalYellow),
                      _buildStatBlock('FOLLOWERS', '2.4K', _brutalPink),
                      _buildStatBlock('FOLLOWING', '891', _brutalGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBlock(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: _borderColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                color: _rawWhite.withValues(alpha: 0.5),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  SECTION HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionHeader(String title, int index, Color accentColor) {
    final safeIndex = index.clamp(0, _sectionSlides.length - 1);
    return SlideTransition(
      position: _sectionSlides[safeIndex],
      child: FadeTransition(
        opacity: _sectionFades[safeIndex],
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Row(
            children: [
              Container(width: 8, height: 24, color: accentColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _rawWhite,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0)],
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

  // ═══════════════════════════════════════════════════════════
  //  SETTINGS TILE
  // ═══════════════════════════════════════════════════════════
  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
  }) {
    final safeIndex = index.clamp(0, _sectionSlides.length - 1);
    return SlideTransition(
      position: _sectionSlides[safeIndex],
      child: FadeTransition(
        opacity: _sectionFades[safeIndex],
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _BrutalSettingsTile(
            icon: icon,
            label: label,
            accentColor: color,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  LOGOUT BUTTON
  // ═══════════════════════════════════════════════════════════
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        // Handle logout
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _brutalRed,
          border: Border.all(color: _rawWhite, width: 3),
          boxShadow: const [BoxShadow(color: _rawWhite, offset: Offset(5, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: _rawWhite, size: 20),
            const SizedBox(width: 12),
            Text(
              'LOG OUT',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: _rawWhite,
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
//  BRUTAL SETTINGS TILE (Stateful for tap animation)
// ═══════════════════════════════════════════════════════════════
class _BrutalSettingsTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;

  const _BrutalSettingsTile({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  @override
  State<_BrutalSettingsTile> createState() => _BrutalSettingsTileState();
}

class _BrutalSettingsTileState extends State<_BrutalSettingsTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _pressOffset;
  bool _isPressed = false;

  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _gridGray = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressOffset = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressOffset,
      builder: (context, child) {
        final offset = _pressOffset.value * 4;
        return Transform.translate(
          offset: Offset(offset, offset),
          child: Container(
            decoration: BoxDecoration(
              color: _gridGray,
              border: Border.all(
                color: _isPressed
                    ? widget.accentColor
                    : _rawWhite.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withValues(alpha: 0.6),
                  offset: Offset(4 - offset, 4 - offset),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: () {},
                splashColor: widget.accentColor.withValues(alpha: 0.15),
                highlightColor: widget.accentColor.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _bgBlack,
                          border: Border.all(
                            color: widget.accentColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.accentColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.label.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _rawWhite,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      // Arrow
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _rawWhite.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: widget.accentColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SMALL BRUTAL BUTTON
// ═══════════════════════════════════════════════════════════════
class _BrutalSmallButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BrutalSmallButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_BrutalSmallButton> createState() => _BrutalSmallButtonState();
}

class _BrutalSmallButtonState extends State<_BrutalSmallButton> {
  bool _pressed = false;

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
          _pressed ? 2 : 0,
          _pressed ? 2 : 0,
          0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A0A0A),
              offset: Offset(_pressed ? 1 : 3, _pressed ? 1 : 3),
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0A0A0A),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
