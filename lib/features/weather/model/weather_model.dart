class WeatherModel {
  final String city;
  final double temperature;
  final String description;

  const WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: (json['name'] as String?) ?? 'Unknown',
      temperature: (json['main']?['temp'] as num?)?.toDouble() ?? 0,
      description:
          (json['weather'] as List?)?.firstOrNull?['description'] as String? ??
          'No description',
    );
  }
}
