import 'dart:convert';
import 'character_mastery.dart';
import 'game_settings.dart';
import 'high_score.dart';
import 'user_progression.dart';

class UserDataBackup {
  static const String currentFormat = 'bunbungo_user_data_backup';
  static const int currentFormatVersion = 1;

  final String format;
  final int formatVersion;
  final String appVersion;
  final String exportedAt;
  final String? lastExportedAt;
  final String? lastImportedAt;
  final Map<String, dynamic> deviceInfo;
  final UserProgression progression;
  final Map<String, CharacterMastery> mastery;
  final List<HighScoreRecord> highScores;
  final StoredGameSettings settings;

  const UserDataBackup({
    this.format = currentFormat,
    this.formatVersion = currentFormatVersion,
    required this.appVersion,
    required this.exportedAt,
    this.lastExportedAt,
    this.lastImportedAt,
    required this.deviceInfo,
    required this.progression,
    required this.mastery,
    required this.highScores,
    this.settings = const StoredGameSettings(),
  });

  Map<String, dynamic> toJson() => {
        'format': format,
        'formatVersion': formatVersion,
        'appVersion': appVersion,
        'exportedAt': exportedAt,
        'lastExportedAt': lastExportedAt,
        'lastImportedAt': lastImportedAt,
        'deviceInfo': deviceInfo,
        'userData': {
          'progression': progression.toJson(),
          'mastery': {
            for (final entry in mastery.entries) entry.key: entry.value.toJson(),
          },
          'highScores': highScores.map((h) => h.toJson()).toList(),
          'settings': settings.toJson(),
        },
      };

  factory UserDataBackup.fromJson(Map<String, dynamic> json) {
    final format = json['format']?.toString() ?? currentFormat;
    final formatVersion = (json['formatVersion'] as num?)?.toInt() ?? 1;
    final appVersion = json['appVersion']?.toString() ?? '1.0.0';
    final exportedAt = json['exportedAt']?.toString() ?? DateTime.now().toIso8601String();
    final lastExportedAt = json['lastExportedAt']?.toString();
    final lastImportedAt = json['lastImportedAt']?.toString();

    final rawDevice = json['deviceInfo'];
    final Map<String, dynamic> deviceInfo = rawDevice is Map
        ? Map<String, dynamic>.from(rawDevice)
        : {};

    final userDataRaw = json['userData'] is Map ? json['userData'] as Map : json;

    UserProgression progression = const UserProgression();
    if (userDataRaw['progression'] is Map) {
      progression = UserProgression.fromJson(
        Map<String, dynamic>.from(userDataRaw['progression'] as Map),
      );
    }

    final Map<String, CharacterMastery> mastery = {};
    if (userDataRaw['mastery'] is Map) {
      final rawMastery = userDataRaw['mastery'] as Map;
      for (final entry in rawMastery.entries) {
        if (entry.value is Map) {
          mastery[entry.key.toString()] = CharacterMastery.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }

    final List<HighScoreRecord> highScores = [];
    if (userDataRaw['highScores'] is List) {
      for (final item in userDataRaw['highScores'] as List) {
        if (item is Map) {
          highScores.add(HighScoreRecord.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    StoredGameSettings settings = const StoredGameSettings();
    if (userDataRaw['settings'] is Map) {
      settings = StoredGameSettings.fromJson(
        Map<String, dynamic>.from(userDataRaw['settings'] as Map),
      );
    }

    return UserDataBackup(
      format: format,
      formatVersion: formatVersion,
      appVersion: appVersion,
      exportedAt: exportedAt,
      lastExportedAt: lastExportedAt,
      lastImportedAt: lastImportedAt,
      deviceInfo: deviceInfo,
      progression: progression,
      mastery: mastery,
      highScores: highScores,
      settings: settings,
    );
  }

  String toFormattedJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}
