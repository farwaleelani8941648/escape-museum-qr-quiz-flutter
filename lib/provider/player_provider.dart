// lib/provider/player_provider.dart

import 'package:flutter/material.dart';

/// PlayerProvider: Manages and provides the player's name across the app.
class PlayerProvider with ChangeNotifier {
  String _playerName = '';

  /// Returns the current player's name.
  String get playerName => _playerName;

  /// Sets the player's name, trims whitespace, and notifies listeners.
  void setPlayerName(String name) {
    _playerName = name.trim();
    notifyListeners();
  }

  /// Returns the player's name with the first letter capitalized.
  String get capitalizedName {
    if (_playerName.isEmpty) return '';
    return _playerName[0].toUpperCase() + _playerName.substring(1).toLowerCase();
  }
}

