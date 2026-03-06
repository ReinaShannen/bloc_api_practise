import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/weather/bloc/weather_bloc.dart';
import 'features/weather/repository/weather_repository.dart';
import 'features/weather/services/weather_services.dart';
import 'features/weather/ui/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WeatherRepository(WeatherService()),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => WeatherBloc(context.read<WeatherRepository>()),
            child: MaterialApp(
              title: 'Bloc Weather',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                textTheme: ThemeData.light().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
              ),
              home: const WeatherPage(),
            ),
          );
        },
      ),
    );
  }
}
