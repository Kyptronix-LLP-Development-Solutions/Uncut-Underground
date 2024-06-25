import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* ---------------------------- jost text widget ---------------------------- */

class CustomTextWidget01 extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize, letterSpacing;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CustomTextWidget01({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jost(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 16.0,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
    );
  }
}

/* -------------------------- montserrat text widget ------------------------- */

class CustomTextWidget02 extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize, letterSpacing;
  final FontWeight? fontWeight;

  const CustomTextWidget02({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 16.0,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
