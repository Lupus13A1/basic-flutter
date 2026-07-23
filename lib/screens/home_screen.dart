import 'package:basic_app/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final AnimationController _cardsController;
  late final AnimationController _floatingController;

  late final Animation<double> _headerSlide;
  late final Animation<double> _headerFade;
  late final Animation<double> _titleScale;

  // Staggered card animations
  late final List<Animation<Offset>> _cardSlides;
  late final List<Animation<double>> _cardFades;

  // Floating idle
  late final Animation<double> _floatingOffset;

  // ── Brutalist Color Palette (matches profile) ──
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

    // Header entrance
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerSlide = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _titleScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Card stagger entrance
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    const cardCount = 6;
    _cardSlides = List.generate(cardCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.35).clamp(0.0, 1.0);
      final direction =
          i.isEven ? const Offset(-1.2, 0) : const Offset(1.2, 0);
      return Tween<Offset>(begin: direction, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    _cardFades = List.generate(cardCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Floating idle animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatingOffset = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profiles');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _brutalYellow,
            content: Text(
              'COMING SOON',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w800,
                color: _bgBlack,
                letterSpacing: 2,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 0,
        onTap: (index) => _handleBottomNavTap(context, index),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _headerController,
          _cardsController,
          _floatingController,
        ]),
        builder: (context, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Brutal Header ──
              SliverToBoxAdapter(child: _buildBrutalHeader()),

              // ── Welcome Banner ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: _buildWelcomeBanner(),
                ),
              ),

              // ── Quick Actions Section ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 12),
                    _buildSectionLabel('QUICK ACTIONS', _brutalYellow, 0),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.explore,
                            label: 'EXPLORE',
                            color: _brutalBlue,
                            index: 1,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.people,
                            label: 'COMMUNITY',
                            color: _brutalPink,
                            index: 2,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.leaderboard,
                            label: 'RANKINGS',
                            color: _brutalGreen,
                            index: 3,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.bookmark,
                            label: 'SAVED',
                            color: _brutalYellow,
                            index: 4,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionLabel('RECENT ACTIVITY', _brutalPink, 5),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      title: 'New follower request',
                      subtitle: '2 minutes ago',
                      icon: Icons.person_add,
                      color: _brutalBlue,
                    ),
                    _buildActivityItem(
                      title: 'Post reached 100 likes',
                      subtitle: '15 minutes ago',
                      icon: Icons.favorite,
                      color: _brutalRed,
                    ),
                    _buildActivityItem(
                      title: 'Achievement unlocked',
                      subtitle: '1 hour ago',
                      icon: Icons.emoji_events,
                      color: _brutalYellow,
                    ),
                    _buildActivityItem(
                      title: 'Community update',
                      subtitle: '3 hours ago',
                      icon: Icons.campaign,
                      color: _brutalGreen,
                    ),
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
              // Brutalist logo block
              Container(
                decoration: BoxDecoration(
                  color: _bgBlack,
                  border: Border.all(color: _rawWhite, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.bolt, color: _brutalYellow, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Transform.scale(
                  scale: _titleScale.value,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HOME',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: _bgBlack,
                      letterSpacing: 4,
                      height: 1,
                    ),
                  ),
                ),
              ),
              // Decorative element
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _brutalRed,
                  border: Border.all(color: _bgBlack, width: 3),
                ),
                child: Center(
                  child: Container(width: 12, height: 12, color: _brutalYellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  WELCOME BANNER
  // ═══════════════════════════════════════════════════════════
  Widget _buildWelcomeBanner() {
    return AnimatedBuilder(
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
          border: Border.all(color: _rawWhite, width: 3),
          boxShadow: const [
            BoxShadow(color: _brutalYellow, offset: Offset(6, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rainbow accent bar
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glitch-style greeting
                  Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(2, 2),
                        child: Text(
                          'WELCOME BACK',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: _brutalRed.withValues(alpha: 0.4),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      Text(
                        'WELCOME BACK',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: _rawWhite,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _brutalYellow.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'YOUR DASHBOARD IS READY',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: _brutalYellow,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    children: [
                      _buildMiniStat('12', 'NEW', _brutalBlue),
                      const SizedBox(width: 16),
                      _buildMiniStat('89', 'ACTIVE', _brutalGreen),
                      const SizedBox(width: 16),
                      _buildMiniStat('3', 'ALERTS', _brutalRed),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _bgBlack,
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), offset: const Offset(3, 3))],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 8,
              color: _rawWhite.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  SECTION LABEL
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionLabel(String title, Color color, int index) {
    final safeIndex = index.clamp(0, _cardSlides.length - 1);
    return SlideTransition(
      position: _cardSlides[safeIndex],
      child: FadeTransition(
        opacity: _cardFades[safeIndex],
        child: Row(
          children: [
            Container(width: 8, height: 24, color: color),
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
                    colors: [color, color.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  QUICK ACTION CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
    required VoidCallback onTap,
  }) {
    final safeIndex = index.clamp(0, _cardSlides.length - 1);
    return SlideTransition(
      position: _cardSlides[safeIndex],
      child: FadeTransition(
        opacity: _cardFades[safeIndex],
        child: _BrutalActionCard(
          icon: icon,
          label: label,
          accentColor: color,
          onTap: onTap,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ACTIVITY ITEM
  // ═══════════════════════════════════════════════════════════
  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: _gridGray,
          border: Border.all(color: _rawWhite.withValues(alpha: 0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _bgBlack,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _rawWhite,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: _rawWhite.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _rawWhite.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.arrow_forward, color: color, size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BRUTAL ACTION CARD (Stateful for tap animation)
// ═══════════════════════════════════════════════════════════════
class _BrutalActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  const _BrutalActionCard({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_BrutalActionCard> createState() => _BrutalActionCardState();
}

class _BrutalActionCardState extends State<_BrutalActionCard>
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressOffset,
      builder: (context, child) {
        final offset = _pressOffset.value * 4;
        return GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _pressController.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _pressController.reverse();
            widget.onTap();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _pressController.reverse();
          },
          child: Transform.translate(
            offset: Offset(offset, offset),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
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
                    offset: Offset(5 - offset, 5 - offset),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _bgBlack,
                      border: Border.all(color: widget.accentColor, width: 2),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.label,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _rawWhite,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
