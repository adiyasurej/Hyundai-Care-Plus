import 'package:flutter/material.dart';

class GlassSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.055,
        ),
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.09,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.18,
            ),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}