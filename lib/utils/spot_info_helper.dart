import 'dart:ui';

import 'package:flutter/material.dart';

class SpotInfoHelper {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'park': return Icons.park;
      case 'school': return Icons.school;
      case 'parkour_gym': return Icons.fitness_center;
      case 'gym': return Icons.sports_gymnastics;
      case 'plaza': return Icons.location_city;
      case 'bridge': return Icons.line_weight;
      default: return Icons.location_on;
    }
  }

  static String getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return '초급';
      case 'intermediate': return '중급';
      case 'advanced': return '고급';
      default: return '중급';
    }
  }

  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return Colors.green;
      case 'intermediate': return Colors.orange;
      case 'advanced': return Colors.red;
      default: return Colors.orange;
    }
  }

  static String getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'park': return '공원';
      case 'school': return '학교';
      case 'parkour_gym': return '파쿠르짐';
      case 'gym': return '체육시설';
      case 'plaza': return '광장';
      case 'bridge': return '다리';
      default: return '일반 스팟';
    }
  }
}