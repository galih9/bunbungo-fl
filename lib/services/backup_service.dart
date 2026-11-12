import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_data_backup.dart';
import 'device_info_helper.dart';
import 'persistence_service.dart';

class UserDataBackupService {
  final PersistenceService persistence;

  UserDataBackupService(this.persistence);

  /// Directory where local BunBunGo backup files (.bbg) are stored
  Future<Directory> getBackupsDirectory() async {
    final isWidgetTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
    if (isWidgetTest) {
      final dir = Directory('${Directory.systemTemp.path}/BunBunGo_Backups');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      return dir;
    }

    try {
      final docDir = await getApplicationDocumentsDirectory()
          .timeout(const Duration(milliseconds: 300));
      final dir = Directory('${docDir.path}/BunBunGo_Backups');
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      return dir;
    } catch (_) {
      final tempDir = Directory.systemTemp;
      final dir = Directory('${tempDir.path}/BunBunGo_Backups');
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      return dir;
    }
  }

  Future<Directory> _getTempDirectory() async {
    final isWidgetTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
    if (isWidgetTest) {
      return Directory.systemTemp;
    }

    try {
      return await getTemporaryDirectory()
          .timeout(const Duration(milliseconds: 300));
    } catch (_) {
      return Directory.systemTemp;
    }
  }

  /// Exports all user data into a .json file, then renames it into .bbg for disguising.
  Future<File> exportUserData({
    Directory? customDirectory,
    String? customFileName,
    String? appVersionOverride,
    Map<String, dynamic>? deviceInfoOverride,
  }) async {
    // 1. Gather all user data from local persistence/database
    final progression = persistence.loadUserProgression();
    final mastery = persistence.loadMasteryMap();
    final highScores = persistence.loadHighScores();
    final settings = persistence.loadGameSettings();

    // 2. Determine App Version
    String appVersion = appVersionOverride ?? '1.1.0';
    if (appVersionOverride == null) {
      try {
        final info = await PackageInfo.fromPlatform();
        appVersion = '${info.version}+${info.buildNumber}';
      } catch (_) {}
    }

    // 3. Collect device metadata
    final deviceInfo = deviceInfoOverride ?? await DeviceInfoHelper.getDeviceInfo();

    // 4. Retrieve timestamps of previous export/import
    final lastExportedAt = persistence.getLastExportDate();
    final lastImportedAt = persistence.getLastImportDate();
    final nowIso = DateTime.now().toIso8601String();

    final backup = UserDataBackup(
      appVersion: appVersion,
      exportedAt: nowIso,
      lastExportedAt: lastExportedAt,
      lastImportedAt: lastImportedAt,
      deviceInfo: deviceInfo,
      progression: progression,
      mastery: mastery,
      highScores: highScores,
      settings: settings,
    );

    // 5. Pack data into JSON formatted text
    final jsonText = backup.toFormattedJson();

    // 6. Target directory & file name
    final Directory dir = customDirectory ?? await getBackupsDirectory();
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }

    final timestampSafe = nowIso.replaceAll(':', '-').replaceAll('.', '_');
    final baseName = customFileName ?? 'bunbungo_userdata_$timestampSafe';

    // 7. Write to .json file first
    final jsonFile = File('${dir.path}/$baseName.json');
    await jsonFile.writeAsString(jsonText, flush: true);

    // 8. Rename the file into .bbg for disguising (as requested: disguising real json as .bbg)
    final bbgPath = '${dir.path}/$baseName.bbg';
    // If target .bbg already exists, remove it before renaming
    final existingBbg = File(bbgPath);
    if (existingBbg.existsSync()) {
      await existingBbg.delete();
    }
    final bbgFile = await jsonFile.rename(bbgPath);

    // 9. Save export telemetry to persistence
    await persistence.setLastExportDate(nowIso);
    await persistence.setLastExportDevice(deviceInfo);
    await persistence.setLastExportPath(bbgFile.path);

    return bbgFile;
  }

  /// Inspects a .bbg backup file without applying it to the database.
  /// Renames a working copy to .json, reads the JSON content, and parses it.
  Future<UserDataBackup> inspectBackupFile(File bbgFile) async {
    final path = bbgFile.path;
    if (!path.toLowerCase().endsWith('.bbg')) {
      throw const FormatException('File must have a .bbg extension.');
    }
    if (!await bbgFile.exists()) {
      throw FileSystemException('Backup file not found', path);
    }

    // Create a temporary copy and rename it to .json to process
    final tempDir = await _getTempDirectory();
    final tempBbg = await bbgFile.copy(
      '${tempDir.path}/inspect_${DateTime.now().microsecondsSinceEpoch}.bbg',
    );
    final tempJsonPath = '${tempBbg.path.substring(0, tempBbg.path.length - 4)}.json';
    final jsonFile = await tempBbg.rename(tempJsonPath);

    try {
      final jsonString = await jsonFile.readAsString();
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid JSON payload: root must be an object.');
      }
      return UserDataBackup.fromJson(decoded);
    } finally {
      try {
        if (await jsonFile.exists()) {
          await jsonFile.delete();
        }
      } catch (_) {}
    }
  }

  /// Imports user data from a disguised .bbg file:
  /// 1. Verifies that the file has a .bbg extension.
  /// 2. Renames the file to .json when processing begins.
  /// 3. Consumes the JSON content.
  /// 4. Applies all progression, mastery, high scores, and settings to the database.
  /// 5. Restores original disguising (.bbg) so the file remains intact on disk.
  Future<UserDataBackup> importUserDataFromFile(File bbgFile) async {
    final path = bbgFile.path;
    if (!path.toLowerCase().endsWith('.bbg')) {
      throw const FormatException('Invalid backup file. Only .bbg files are supported for import.');
    }
    if (!await bbgFile.exists()) {
      throw FileSystemException('Backup file does not exist', path);
    }

    // Step: When starting to process the file, rename the file to .json
    File jsonFile;
    final inPlaceJsonPath = '${path.substring(0, path.length - 4)}.json';
    bool wasRenamedInPlace = false;

    try {
      // Remove any leftover .json with that name first
      final existingJson = File(inPlaceJsonPath);
      if (existingJson.existsSync()) {
        await existingJson.delete();
      }
      jsonFile = await bbgFile.rename(inPlaceJsonPath);
      wasRenamedInPlace = true;
    } catch (e) {
      debugPrint('In-place rename failed, copying to temp directory: $e');
      // If direct rename fails (e.g. read-only volume or sandbox restriction),
      // copy to temporary directory with .bbg and then rename to .json
      final tempDir = await _getTempDirectory();
      final tempBbg = await bbgFile.copy(
        '${tempDir.path}/bunbungo_import_${DateTime.now().microsecondsSinceEpoch}.bbg',
      );
      final tempJsonPath = '${tempBbg.path.substring(0, tempBbg.path.length - 4)}.json';
      jsonFile = await tempBbg.rename(tempJsonPath);
    }

    try {
      // Step: Start consuming the json file
      final jsonString = await jsonFile.readAsString();
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Backup file is corrupt: root is not a valid JSON object.');
      }

      final backup = UserDataBackup.fromJson(decoded);

      // Step: Apply data to the database
      await persistence.saveUserProgression(backup.progression);
      await persistence.saveMasteryMap(backup.mastery);
      await persistence.restoreAllHighScores(backup.highScores);
      await persistence.saveGameSettings(backup.settings);

      // Step: Record import telemetry in persistence
      final nowIso = DateTime.now().toIso8601String();
      await persistence.setLastImportDate(nowIso);
      final currentDevice = await DeviceInfoHelper.getDeviceInfo();
      await persistence.setLastImportDevice(
        backup.deviceInfo.isNotEmpty ? backup.deviceInfo : currentDevice,
      );

      return backup;
    } finally {
      // Restore disguising or cleanup temporary files
      try {
        if (wasRenamedInPlace && await jsonFile.exists()) {
          // Rename back to .bbg to keep it disguised
          await jsonFile.rename(bbgFile.path);
        } else if (!wasRenamedInPlace && await jsonFile.exists()) {
          await jsonFile.delete();
        }
      } catch (_) {}
    }
  }

  /// Lists all local .bbg backup files in the backup directory
  Future<List<File>> listLocalBackups() async {
    try {
      final dir = await getBackupsDirectory();
      if (!dir.existsSync()) return [];
      final entities = dir.listSync();
      final files = entities
          .whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.bbg'))
          .toList()
        ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      return files;
    } catch (_) {
      return [];
    }
  }
}
