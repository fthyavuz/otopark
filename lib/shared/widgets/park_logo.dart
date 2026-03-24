import 'package:flutter/material.dart';

/// Simple parking-P logo: white rounded square with a bold blue "P".
class ParkLogo extends StatelessWidget {
  const ParkLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: size * 0.65,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1565C0),
            height: 1,
          ),
        ),
      ),
    );
  }
}
