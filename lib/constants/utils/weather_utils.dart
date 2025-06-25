
import 'package:flutter/material.dart';


LinearGradient getBackgroundGradient(String description) {
  final desc = description.toLowerCase();

  if (desc.contains("clear") || desc.contains("sunny")) {
    return const LinearGradient(
      colors: [Color(0xFFE2B06C), Color(0xFFC8D8EE,)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("partly") || desc.contains("few clouds")) {
    return const LinearGradient(
      colors: [Color(0xFFD7DDE8), Color(0xFF90A4AE)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("cloud")) {
    return const LinearGradient(
      colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("rain")) {
    return const LinearGradient(
      colors: [Color(0xFFC8D8EE), Color(0xFF7D8FA1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("storm") || desc.contains("thunder")) {
    return const LinearGradient(
      colors: [Color(0xFF141E30), Color(0xFF243B55)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("fog") || desc.contains("mist")) {
    return const LinearGradient(
      colors: [Color(0xFF3E5151), Color(0xFFDECBA4)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("snow")) {
    return const LinearGradient(
      colors: [Color(0xFF83A4D4), Color(0xFFB6FBFF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  } else if (desc.contains("night") || desc.contains("moon")) {
    return const LinearGradient(
      colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // Default fallback
  return const LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}


/// دالة لتحديد مسار الأيقونة حسب وصف الطقس
String getWeatherIconPath(String description) {
  final desc = description.toLowerCase();
  if (desc.contains("rain")) {
    return 'assets/images/emojione_sun-behind-cloud.png';
  } else if (desc.contains("clear") || desc.contains("sunny")) {
    return 'assets/images/twemoji_sun-behind-small-cloud.png';
  } else if (desc.contains("cloud")) {
    return 'assets/images/twemoji_sun-behind-rain-cloud.png';
  }
  return 'assets/images/twemoji_sun-behind-small-cloud.png';
}

/// Widget عنصر معلومات الطقس (Min, Max, Humidity, Feels Like)
Widget buildWeatherInfoItem({required String title, required String value}) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
