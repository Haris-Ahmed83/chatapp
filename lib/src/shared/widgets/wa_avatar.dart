import 'package:flutter/material.dart';

class WaAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;
  final bool isOnline;

  const WaAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.radius = 24,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[300],
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: radius * 0.8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.5,
              height: radius * 0.5,
              decoration: const BoxDecoration(
                color: Color(0xFF25D366),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
              ),
            ),
          ),
      ],
    );
  }
}
