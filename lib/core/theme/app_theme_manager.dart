import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'app_theme_extension.dart';

/// Theme event
abstract class ThemeEvent {}

/// Change theme event
class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;

  ChangeTheme(this.themeMode);
}

/// Initialize theme event
class InitializeTheme extends ThemeEvent {}

/// Theme state
class ThemeState {
  final ThemeData themeData;
  final ThemeMode themeMode;

  ThemeState({
    required this.themeData,
    required this.themeMode,
  });

  ThemeState copyWith({
    ThemeData? themeData,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Theme manager using BLoC pattern
class ThemeManager extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'app_theme_mode';
  final SharedPreferences _preferences;

  ThemeManager(this._preferences)
      : super(
          ThemeState(
            themeData: AppTheme.darkTheme.copyWith(
              extensions: [AppThemeExtension.dark],
            ),
            themeMode: ThemeMode.dark,
          ),
        ) {
    on<ChangeTheme>(_onChangeTheme);
    on<InitializeTheme>(_onInitializeTheme);
  }

  Future<void> _onChangeTheme(
      ChangeTheme event, Emitter<ThemeState> emit) async {
    final themeMode = event.themeMode;
    ThemeData themeData;

    switch (themeMode) {
      case ThemeMode.light:
        themeData = AppTheme.lightTheme.copyWith(
          extensions: [AppThemeExtension.light],
        );
        break;
      case ThemeMode.dark:
        themeData = AppTheme.darkTheme.copyWith(
          extensions: [AppThemeExtension.dark],
        );
        break;
      case ThemeMode.system:
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        if (brightness == Brightness.dark) {
          themeData = AppTheme.darkTheme.copyWith(
            extensions: [AppThemeExtension.dark],
          );
        } else {
          themeData = AppTheme.lightTheme.copyWith(
            extensions: [AppThemeExtension.light],
          );
        }
        break;
    }

    // Save theme preference
    await _saveThemePreference(themeMode);

    emit(state.copyWith(
      themeData: themeData,
      themeMode: themeMode,
    ));
  }

  Future<void> _onInitializeTheme(
      InitializeTheme event, Emitter<ThemeState> emit) async {
    final savedThemeMode = await _loadThemePreference();
    add(ChangeTheme(savedThemeMode));
  }

  Future<void> _saveThemePreference(ThemeMode mode) async {
    await _preferences.setString(_themePreferenceKey, mode.toString());
  }

  Future<ThemeMode> _loadThemePreference() async {
    final themeString = _preferences.getString(_themePreferenceKey);

    if (themeString == null) {
      return ThemeMode.dark;
    }

    try {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.dark,
      );
    } catch (e) {
      return ThemeMode.dark;
    }
  }
}
