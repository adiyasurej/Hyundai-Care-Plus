import 'package:flutter/material.dart';

class CareLogo extends StatelessWidget {
  final double size;

  const CareLogo({
    super.key,
    this.size = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF002C5F),
            Color(0xFF0D6EFD),
          ],
        ),

        borderRadius: BorderRadius.circular(
          size * 0.28,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002C5F)
                .withValues(alpha: 0.25),

            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        alignment: Alignment.center,

        children: [

          // Soft glow
          Container(
            width: size * 0.72,
            height: size * 0.72,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.18),

                width: 2,
              ),
            ),
          ),

          // Car
          Icon(
            Icons.directions_car_rounded,
            size: size * 0.45,
            color: Colors.white,
          ),

          // Small care sparkle
          Positioned(
            top: size * 0.12,
            right: size * 0.13,

            child: Icon(
              Icons.auto_awesome,
              size: size * 0.18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}