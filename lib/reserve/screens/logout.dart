import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogoutHandler {
  static Future<bool> logoutUser(BuildContext context) async {
    const String logoutUrl = "http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/auth/logout/"; 

    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Gagal logout
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout failed. Please try again.")),
        );
        return false;
      }
    } catch (e) {
      // Tangani error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      return false;
    }
  }
}
