import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import 'widgets/glass_card.dart';
import 'widgets/glow_orb.dart';
import 'widgets/info_pill.dart';
import 'widgets/search_bar.dart';
import 'widgets/title_section.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchWeather() {
    context.read<WeatherBloc>().add(FetchWeatherEvent(_controller.text.trim()));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B132B), Color(0xFF1C2541), Color(0xFF3A506B)],
          ),
        ),
        child: Stack(
          children: [
            const GlowOrb(
              top: -80,
              left: -60,
              size: 220,
              color: Color(0xFF2EC4B6),
            ),
            const GlowOrb(
              top: 120,
              right: -70,
              size: 180,
              color: Color(0xFFFF9F1C),
            ),
            const GlowOrb(
              bottom: -100,
              left: 40,
              size: 260,
              color: Color(0xFF5BC0EB),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool compactLayout = constraints.maxHeight < 430;
                  final double rawCardHeight = constraints.maxHeight - 178;
                  final double cardHeight = rawCardHeight < 260
                      ? 260
                      : rawCardHeight;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSection(compact: compactLayout),
                            SizedBox(height: compactLayout ? 10 : 20),
                            WeatherSearchBar(
                              controller: _controller,
                              onSearch: _searchWeather,
                            ),
                            SizedBox(height: compactLayout ? 10 : 20),
                            SizedBox(
                              height: cardHeight,
                              child: BlocBuilder<WeatherBloc, WeatherState>(
                                builder: (context, state) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeInCubic,
                                    child: _buildStateCard(state),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCard(WeatherState state) {
    if (state is WeatherLoading) {
      return const GlassCard(
        key: ValueKey('loading'),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(height: 16),
              Text('Pulling live weather data...'),
            ],
          ),
        ),
      );
    }

    if (state is WeatherError) {
      return GlassCard(
        key: const ValueKey('error'),
        tint: const Color(0x66B00020),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (state is WeatherLoaded) {
      final weather = state.weather;
      final gradient = _gradientFor(weather.description);
      final icon = _iconFor(weather.description);

      return GlassCard(
        key: ValueKey('loaded-${weather.city}-${weather.description}'),
        tint: Colors.transparent,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weather.city,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  weather.description.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 1.3,
                                    color: Color(0xCCFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(icon, size: 54, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: weather.temperature),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 76,
                              fontWeight: FontWeight.w800,
                              height: 0.95,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Live from OpenWeather',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xCCFFFFFF),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          InfoPill(icon: Icons.thermostat, label: 'Celsius'),
                          InfoPill(icon: Icons.my_location, label: 'Real-time'),
                          InfoPill(icon: Icons.auto_awesome, label: 'Sky mood'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return const GlassCard(
      key: ValueKey('initial'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.travel_explore_rounded, size: 48, color: Colors.white),
            SizedBox(height: 14),
            Text(
              'Search for a city to reveal live weather',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientFor(String description) {
    final lower = description.toLowerCase();

    if (lower.contains('rain') || lower.contains('drizzle')) {
      return const [Color(0xFF1D3557), Color(0xFF457B9D), Color(0xFF4CC9F0)];
    }
    if (lower.contains('cloud') ||
        lower.contains('mist') ||
        lower.contains('fog')) {
      return const [Color(0xFF3A506B), Color(0xFF5BC0BE), Color(0xFFA8DADC)];
    }
    if (lower.contains('clear') || lower.contains('sun')) {
      return const [Color(0xFFFF6B35), Color(0xFFFFA62B), Color(0xFFFFD166)];
    }
    return const [Color(0xFF4361EE), Color(0xFF4CC9F0), Color(0xFF80ED99)];
  }

  IconData _iconFor(String description) {
    final lower = description.toLowerCase();

    if (lower.contains('rain') || lower.contains('drizzle')) {
      return Icons.umbrella_rounded;
    }
    if (lower.contains('cloud')) {
      return Icons.cloud_rounded;
    }
    if (lower.contains('mist') || lower.contains('fog')) {
      return Icons.grain_rounded;
    }
    if (lower.contains('clear') || lower.contains('sun')) {
      return Icons.wb_sunny_rounded;
    }
    return Icons.wb_twilight_rounded;
  }
}
