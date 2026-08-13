import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final Animation<double> _headerSlide;
  late final Animation<double> _headerFade;

  late final AnimationController _listController;
  late final List<Animation<Offset>> _itemSlides;
  late final List<Animation<double>> _itemFades;

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
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerSlide = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    const itemCount = 6;
    _itemSlides = List.generate(itemCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.35).clamp(0.0, 1.0);
      final direction = i.isEven ? const Offset(-1.2, 0) : const Offset(1.2, 0);
      return Tween<Offset>(begin: direction, end: Offset.zero).animate(
        CurvedAnimation(parent: _listController, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      );
    });
    _itemFades = List.generate(itemCount, (i) {
      final start = (i * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _listController, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerController,
              builder: (context, _) => _buildBrutalHeader(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: AnimatedBuilder(
              animation: _listController,
              builder: (context, _) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    _buildAnimatedItem(
                      0,
                      _buildProjectCard('Lerner App', 'Mobile App in Flutter', 'IN PROGRESS', _brutalYellow),
                    ),
                    _buildAnimatedItem(
                      1,
                      _buildProjectCard('Cyber API', 'Go Backend Microservice', 'BLOCKED', _brutalRed),
                    ),
                    _buildAnimatedItem(
                      2,
                      _buildProjectCard('Web3 Portal', 'React/NextJS Frontend', 'PLANNING', _brutalBlue),
                    ),
                    _buildAnimatedItem(
                      3,
                      _buildProjectCard('Dev:Grid', 'Brutalist UI Kit', 'DEPLOYED', _brutalGreen),
                    ),
                    _buildAnimatedItem(
                      4,
                      _buildProjectCard('Synth UI', 'Experimental Design System', 'PAUSED', _brutalPink),
                    ),
                    const SizedBox(height: 60),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _brutalYellow,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: _rawWhite, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        child: const Icon(Icons.add, color: _bgBlack, size: 28),
      ),
    );
  }

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
              Container(
                decoration: BoxDecoration(
                  color: _bgBlack,
                  border: Border.all(color: _rawWhite, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.code, color: _brutalYellow, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'PROJECTS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _bgBlack,
                    letterSpacing: 4,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    final safeIndex = index.clamp(0, _itemSlides.length - 1);
    return SlideTransition(
      position: _itemSlides[safeIndex],
      child: FadeTransition(
        opacity: _itemFades[safeIndex],
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle, String status, Color statusColor) {
    return Container(
      decoration: BoxDecoration(
        color: _gridGray,
        border: Border.all(color: _rawWhite, width: 2),
        boxShadow: [
          BoxShadow(color: statusColor, offset: const Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _rawWhite.withValues(alpha: 0.2), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _rawWhite,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bgBlack,
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              subtitle,
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                color: _rawWhite.withValues(alpha: 0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Icon(Icons.commit, color: _rawWhite.withValues(alpha: 0.4), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Last update 2h ago',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: _rawWhite.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
