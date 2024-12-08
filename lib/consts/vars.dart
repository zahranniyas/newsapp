import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SortByEnum {
  relevancy,
  popularity,
  publishedAt,
}

TextStyle smallTitle =
    GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700);

TextStyle smallPara = GoogleFonts.lato(fontSize: 12);

TextStyle largeTitle =
    GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.w700);

const List<String> searchKeywords = [
  "Football",
  "Flutter",
  "Python",
  "Weather",
  "Crypto",
  "Sri Lanka",
  "Tech",
  "Science"
];
