import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [
      0,
      0.4,
      1
    ], //tipo opacidade das cores
    colors: [
      Color(0xFF150B0A),
      Color(0xFF1D120E),
      Color(0xFF433613),
    ]);
