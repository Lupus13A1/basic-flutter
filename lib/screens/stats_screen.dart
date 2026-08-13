import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // ── Brutalist Color Palette ──
  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _brutalBlue = Color(0xFF2979FF);
  static const _brutalGreen = Color(0xFF00E676);
  static const _gridGray = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrutalHeader(),
              const SizedBox(height: 32),
              _buildStatCard('TOTAL COMMITS', '4,281', _brutalBlue),
              const SizedBox(height: 16),
              _buildStatCard('LONGEST STREAK', '14 DAYS', _brutalYellow),
              const SizedBox(height: 16),
              _buildStatCard('TASKS COMPLETED', '128', _brutalGreen),
              const SizedBox(height: 32),
              Text(
                'WEEKLY ACTIVITY',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _rawWhite,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrutalHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _brutalBlue,
        border: Border(bottom: BorderSide(color: _bgBlack, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _bgBlack,
              border: Border.all(color: _rawWhite, width: 2),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.bar_chart, color: _brutalBlue, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'STATS',
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
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _gridGray,
        border: Border.all(color: _rawWhite, width: 2),
        boxShadow: [
          BoxShadow(color: color, offset: const Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              color: _rawWhite.withValues(alpha: 0.6),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgBlack,
        border: Border.all(color: _rawWhite.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar(40, _brutalBlue, 'M'),
          _buildBar(80, _brutalBlue, 'T'),
          _buildBar(120, _brutalYellow, 'W'),
          _buildBar(60, _brutalBlue, 'T'),
          _buildBar(90, _brutalBlue, 'F'),
          _buildBar(20, _brutalGreen, 'S'),
          _buildBar(30, _brutalGreen, 'S'),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color, String day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: _rawWhite, width: 2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.spaceMono(
            fontSize: 12,
            color: _rawWhite.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
