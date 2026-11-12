// ignore_for_file: avoid_print
import 'dart:io';

void main(List<String> args) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ Error: pubspec.yaml not found. Please run this script from the project root.');
    exit(1);
  }

  final lines = pubspecFile.readAsLinesSync();
  int versionLineIndex = -1;
  String currentVersionStr = '';

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().startsWith('version:')) {
      versionLineIndex = i;
      currentVersionStr = line.split(':')[1].trim();
      break;
    }
  }

  if (versionLineIndex == -1) {
    print('❌ Error: "version:" line not found in pubspec.yaml.');
    exit(1);
  }

  // Parse current version: format is X.Y.Z+N
  final versionParts = currentVersionStr.split('+');
  final semver = versionParts[0].trim();
  int buildNumber = versionParts.length > 1 ? int.tryParse(versionParts[1].trim()) ?? 1 : 1;

  final semverParts = semver.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  while (semverParts.length < 3) {
    semverParts.add(0);
  }
  int major = semverParts[0];
  int minor = semverParts[1];
  int patch = semverParts[2];

  if (args.isEmpty || args[0] == 'show' || args[0] == 'status') {
    print('📦 BunBunGo Current Version:');
    print('   • Semantic Version (versionName): $major.$minor.$patch');
    print('   • Build Number (versionCode):     $buildNumber');
    print('   • Full pubspec version string:    $major.$minor.$patch+$buildNumber');
    print('');
    print('Usage:');
    print('   dart run tool/version.dart show          # Displays current version');
    print('   dart run tool/version.dart bump build    # Increments build number ($major.$minor.$patch+${buildNumber + 1})');
    print('   dart run tool/version.dart bump patch    # Bumps patch ($major.$minor.${patch + 1}+${buildNumber + 1})');
    print('   dart run tool/version.dart bump minor    # Bumps minor ($major.${minor + 1}.0+${buildNumber + 1})');
    print('   dart run tool/version.dart bump major    # Bumps major (${major + 1}.0.0+${buildNumber + 1})');
    print('   dart run tool/version.dart set <ver+num> # e.g. 1.2.0+15');
    return;
  }

  final command = args[0].toLowerCase();

  String newVersionStr = '';
  if (command == 'bump') {
    final bumpType = args.length > 1 ? args[1].toLowerCase() : 'build';
    switch (bumpType) {
      case 'build':
        buildNumber += 1;
        newVersionStr = '$major.$minor.$patch+$buildNumber';
        break;
      case 'patch':
        patch += 1;
        buildNumber += 1;
        newVersionStr = '$major.$minor.$patch+$buildNumber';
        break;
      case 'minor':
        minor += 1;
        patch = 0;
        buildNumber += 1;
        newVersionStr = '$major.$minor.$patch+$buildNumber';
        break;
      case 'major':
        major += 1;
        minor = 0;
        patch = 0;
        buildNumber += 1;
        newVersionStr = '$major.$minor.$patch+$buildNumber';
        break;
      default:
        print('❌ Unknown bump target: "$bumpType". Use build, patch, minor, or major.');
        exit(1);
    }
  } else if (command == 'set') {
    if (args.length < 2) {
      print('❌ Error: Expected version string. Example: dart run tool/version.dart set 1.1.0+2');
      exit(1);
    }
    newVersionStr = args[1].trim();
    if (!newVersionStr.contains('+')) {
      newVersionStr = '$newVersionStr+1';
    }
  } else {
    print('❌ Unknown command: "$command". Run "dart run tool/version.dart show" for help.');
    exit(1);
  }

  lines[versionLineIndex] = 'version: $newVersionStr';
  pubspecFile.writeAsStringSync('${lines.join('\n')}\n');

  print('✅ Successfully updated BunBunGo version:');
  print('   Old: $currentVersionStr');
  print('   New: $newVersionStr');
}
