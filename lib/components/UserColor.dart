import 'package:flutter/material.dart';
import 'package:quiver/core.dart';

class UserColorUtil {
  static Color getUserColor(String userId, List<Color> colors) {
    // Remove any unnecessary characters (e.g., hyphens) from the userId
    final cleanId = userId.replaceAll('-', '');

    // Use Quiver's hash function to hash the username string into a number
    final hash = hashObjects(cleanId.codeUnits);

    // Use the hash to get an index within the colors list
    final index = hash.abs() % colors.length;

    // Return the color at the calculated index
    return colors[index];
  }
}