import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text T(String text, double size) {
  return Text(text,
      style: GoogleFonts.getFont('Open Sans',
          fontWeight: FontWeight.w500, fontSize: size));
}

Text T2(String text, double size) {
  return Text(text,
      style: GoogleFonts.getFont('Open Sans',
          fontWeight: FontWeight.w400, fontSize: size));
}

Text T3(String text, double size) {
  return Text(text,
      style: GoogleFonts.getFont('Open Sans',
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: size));
}
