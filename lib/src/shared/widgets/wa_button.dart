import 'package:flutter/material.dart';

class WaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final double? width;
  final double height;

  const WaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF075E54),
          foregroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
