import 'package:basic_app/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimary,
  );

  static TextStyle bodySecondary = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColor.textSecondary,
  );

  static TextStyle bodyEmphasis = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimary,
  );
}
