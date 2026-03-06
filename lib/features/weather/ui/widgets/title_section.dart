import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SkyCast',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: Colors.white,
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 4),
          const Text(
            'Weather with style, updated in real time',
            style: TextStyle(fontSize: 14, color: Color(0xCCFFFFFF)),
          ),
        ],
      ],
    );
  }
}
