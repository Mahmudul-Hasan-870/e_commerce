import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget shippingTextField(String labelText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      labelText: labelText,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black54,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 2.0,
        ),
      ),
    ),
    style: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black87,
    ),
  );
}
