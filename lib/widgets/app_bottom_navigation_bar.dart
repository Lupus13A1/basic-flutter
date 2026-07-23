import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _bgBlack = Color(0xFF0A0A0A);
  static const _rawWhite = Color(0xFFF5F0E8);
  static const _brutalYellow = Color(0xFFFFE135);
  static const _gridGray = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bgBlack,
        border: Border(top: BorderSide(color: _rawWhite, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: List.generate(3, (i) {
              final isSelected = i == selectedIndex;
              final icons = [Icons.home, Icons.search, Icons.person];
              final labels = ['HOME', 'SEARCH', 'PROFILE'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? _brutalYellow : _gridGray,
                      border: Border.all(
                        color: isSelected ? _brutalYellow : _rawWhite.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? const [BoxShadow(color: _brutalYellow, offset: Offset(3, 3))]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[i],
                          size: 22,
                          color: isSelected ? _bgBlack : _rawWhite.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? _bgBlack : _rawWhite.withValues(alpha: 0.5),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
