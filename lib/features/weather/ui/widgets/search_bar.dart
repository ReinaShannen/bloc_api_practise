import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherSearchBar extends StatelessWidget {
  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0x33FFFFFF),
            border: Border.all(color: const Color(0x66FFFFFF), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onSubmitted: (_) => onSearch(),
                  decoration: const InputDecoration(
                    hintText: 'Try Chennai, Tokyo, or New York',
                    hintStyle: TextStyle(color: Color(0xAAFFFFFF)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9F1C), Color(0xFFFFBF69)],
                  ),
                ),
                child: IconButton(
                  onPressed: onSearch,
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF1B1B2F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
